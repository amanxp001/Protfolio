-- delecting data that we are going to use
select Location, date, total_cases, new_cases, total_deaths, population
from protfolio..covid_deaths$
order by 1,2



--total cases vs total deaths

select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercentage
from protfolio..covid_deaths$
order by 1,2

-- showing what percentage of population got covid

select Location, date,population, total_cases, total_deaths, (total_cases/population)*100 as percentagepeoplegotcovid
from protfolio..covid_deaths$
order by 1,2


--contries with highest infection rate

select Location, population, max(total_cases) as highestinfectioncount, max((total_cases/population))*100 as percentagepeoplegotcovid
from protfolio..covid_deaths$
group by population, location
order by percentagepeoplegotcovid desc 

--countries with highest death count
select Location, max(cast (total_deaths as int)) as totaldeathcount
from protfolio..covid_deaths$
where continent is not null
group by  location
order by totaldeathcount desc 


-- temp table
drop table if exists #percentpeoplevaccinated

create table #percentpeoplevaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
totalpeoplevaccinated numeric
)

insert into #percentpeoplevaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as totalpeoplevaccinated
from protfolio..covid_deaths$ dea
join protfolio..covid_vac$ vac
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null

select *, (totalpeoplevaccinated/population)*100
from #percentpeoplevaccinated
order by 2,3


--creating view

create view percentpeoplevaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as totalpeoplevaccinated
from protfolio..covid_deaths$ dea
join protfolio..covid_vac$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null