--Cleaning data project

--Standardize Date Format

select SaleDate
cast(saledate as date)
--update NashvilleHousing
--set saledate = cast(saledate as date)
from SQLProject..NashvilleHousing
-- the above update didn't work so i will use the alter command
Alter table NashvilleHousing
ADD ConvertedSaleDate date

--time to add the saledate in the standardized format to the new column

update NashvilleHousing
set ConvertedSaleDate = cast(saledate as date)

--time to delete the old column

alter table NashvilleHousing
drop column SaleDate

-----------------------------------------------------------------------
--Populating Property Address

select *
from NashvilleHousing
--where PropertyAddress is  null
order by ParcelID

select NH1.ParcelID, NH1.PropertyAddress, NH2.ParcelID, NH2.PropertyAddress, ISNULL(nh1.propertyaddress, nh2.PropertyAddress)
from NashvilleHousing NH1
join NashvilleHousing NH2
on NH1.ParcelID = NH2.ParcelID
and NH1.[UniqueID ] <> NH2.[UniqueID ]
WHERE NH1.PropertyAddress IS NULL

update NH1
set PropertyAddress = ISNULL(nh1.propertyaddress, nh2.PropertyAddress)	
from NashvilleHousing NH1
join NashvilleHousing NH2
on NH1.ParcelID = NH2.ParcelID
and NH1.[UniqueID ] <> NH2.[UniqueID ]
WHERE NH1.PropertyAddress IS NULL

--------------------------------------------
--Splitting property adress into different columns

select 
--substring(PropertyAddress,1,charindex(',', PropertyAddress)-1) as StreetAddress,
substring(PropertyAddress ,charindex(',', PropertyAddress)+1 ,len(PropertyAddress)) as Town

from NashvilleHousing

Alter table nashvillehousing
add StreetName Varchar(255)
add Town varchar(255)

update NashvilleHousing
set StreetName = substring(PropertyAddress,1,charindex(',', PropertyAddress)-1)
set Town = substring(PropertyAddress ,charindex(',', PropertyAddress)+1 ,len(PropertyAddress))


select * from NashvilleHousing

alter table NashvilleHousing
drop column PropertyAddress

-- Time to do the same to the Owner Address
select 
parsename(Replace(OwnerAddress, ',','.') , 3),
parsename(Replace(OwnerAddress, ',','.') , 2),
parsename(Replace(OwnerAddress, ',','.') , 1)
from NashvilleHousing

alter table NashVilleHousing
add OwnerStreet varchar(255)
add OwnerTown Varchar(255)
add OwnerState Varchar(255)

update NashvilleHousing
set OwnerStreet = parsename(Replace(OwnerAddress, ',','.') , 3)
update NashvilleHousing
set OwnerTown = parsename(Replace(OwnerAddress, ',','.') , 2)
update NashvilleHousing
set OwnerState = parsename(Replace(OwnerAddress, ',','.') , 1)


select * from NashvilleHousing

------------------------
--Replacing Y AND N with Yes and NO in the SoldAsVacant column

select SoldasVacant
from NashvilleHousing
group by SoldAsVacant

update NashvilleHousing
set SoldAsVacant = CASE
						WHEN SoldAsVacant = 'Yes' THEN 'Yes'
						when SoldAsVacant = 'N' THEN 'No'
						ELSE SoldAsVacant
						end


------------------------------------------------
---Deleting duplicates
with Row_NumCTE as (
select *, row_number () over (
		Partition by ParcelID,
		StreetName,
		SalePrice,
		ConvertedSaleDate,
		LegalReference
		order by UniqueID
		) as row_num
from NashvilleHousing
)

select * from Row_NumCTE
where row_num > 1

--------------------------------------
--Delete Unusable columns

select * from NashvilleHousing

alter table NashvilleHousing

drop column TaxDistrict, OwnerAddress

