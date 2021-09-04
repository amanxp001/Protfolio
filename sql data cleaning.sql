select *
from protfolio.dbo.Sheet1$


-- converting date format

select SaleDate, CONVERT(date,SaleDate)
from protfolio.dbo.Sheet1$

alter table dbo.sheet1$
add saledateconverted Date;


update dbo.Sheet1$ 
set saledateconverted = CONVERT(date,SaleDate)

--dropping old sale date column

alter table dbo.sheet1$
drop column SaleDate

-- populating column where propertyadress in null and checking duplicates in parcel id column
select PropertyAddress, ParcelID
from protfolio.dbo.Sheet1$
where propertyaddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from protfolio.dbo.Sheet1$ a
join protfolio.dbo.Sheet1$ b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a 
set PropertyAddress	= ISNULL(a.PropertyAddress,b.PropertyAddress)
from protfolio.dbo.Sheet1$ a
join protfolio.dbo.Sheet1$ b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- breaking out propertyaddress into (City, address, state)

select PropertyAddress
from protfolio.dbo.Sheet1$

select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1,LEN(PropertyAddress)) as city
from protfolio.dbo.Sheet1$

	ALTER TABLE protfolio.dbo.Sheet1$
	Add PropertySplitAddress Nvarchar(255);
	

	Update protfolio.dbo.Sheet1$
	SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )
	


	ALTER TABLE protfolio.dbo.Sheet1$
	Add PropertySplitCity Nvarchar(255);
	

	Update protfolio.dbo.Sheet1$
	SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))
	

	Select *
	From protfolio.dbo.Sheet1$
	


select
PARSENAME(REPLACE(OwnerAddress, ',','.') ,3)
,PARSENAME(REPLACE(OwnerAddress, ',','.') ,2)
,PARSENAME(REPLACE(OwnerAddress, ',','.') ,1)
from protfolio.dbo.Sheet1$

ALTER TABLE protfolio.dbo.Sheet1$
Add OwnerSplitAddress Nvarchar(255);


Update protfolio.dbo.Sheet1$
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)




ALTER TABLE protfolio.dbo.Sheet1$
Add OwnerSplitCity Nvarchar(255);


Update protfolio.dbo.Sheet1$
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)






ALTER TABLE protfolio.dbo.Sheet1$
Add OwnerSplitState Nvarchar(255);


Update protfolio.dbo.Sheet1$
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)






Select *
From protfolio.dbo.Sheet1$



Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From protfolio.dbo.Sheet1$
Group by SoldAsVacant
order by 2

select SoldAsVacant 
,case when SoldAsVacant = 'Y' then 'Yes'
           when SoldAsVacant = 'N' then 'No'
		   else SoldAsVacant
		   End
From protfolio.dbo.Sheet1$


	Update protfolio.dbo.Sheet1$
	SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
		   When SoldAsVacant = 'N' THEN 'No'
		   ELSE SoldAsVacant
		   END
	
	

-- Remove Duplicates


WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 saledateconverted,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num


From protfolio.dbo.Sheet1$
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress






Select *
From protfolio.dbo.Sheet1$



	

	-- Delete Unused Columns
	

	

	

	Select *
	From protfolio.dbo.Sheet1$
	

	

	ALTER TABLE protfolio.dbo.Sheet1$
	DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress
