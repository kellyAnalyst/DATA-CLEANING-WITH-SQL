SELECT * 
FROM PortfolioProject. .NashvielleHousing


--Standardize Date Format


Select SaleDateConverted, CONVERT(Date, SaleDate)
from PortfolioProject. .NashvielleHousing

update NashvielleHousing 
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvielleHousing
add SaleDateConverted Date;

update NashvielleHousing
set SaleDateConverted = CONVERT(Date, SaleDate)



--Populate property Address data 

select *
from PortfolioProject. .NashvielleHousing
--where PropertyAddress is null
order by ParcelID

select  A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress,B.PropertyAddress)
from PortfolioProject. .NashvielleHousing A
JOIN PortfolioProject. .NashvielleHousing B
  ON A.ParcelID = B.ParcelID
  AND A.[UniqueID ] <> B.[UniqueID ]
  WHERE A.PropertyAddress IS NULL

  UPDATE A
  SET PropertyAddress = ISNULL(A.PropertyAddress,B.PropertyAddress)
  from PortfolioProject. .NashvielleHousing A
JOIN PortfolioProject. .NashvielleHousing B
  ON A.ParcelID = B.ParcelID
  AND A.[UniqueID ] <> B.[UniqueID ]
  where A.PropertyAddress is null



  --Breaking address into individual columns( address, city, state)



  select PropertyAddress
  from PortfolioProject. .NashvielleHousing
  --where PropertyAddress is null
  --order by ParcelID

  select 
  SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
    SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) +1 , len(PropertyAddress)) as Address

  from PortfolioProject. .NashvielleHousing


  alter table NashvielleHousing
  add PropertySplitAddress Nvarchar(255);

  update NashvielleHousing
  set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

    alter table NashvielleHousing
  add PropertySplitCity Nvarchar(255);

  update NashvielleHousing
  set PropertySplitCity =  SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) +1 , len(PropertyAddress))

  SELECT * 
  FROM PortfolioProject. .NashvielleHousing




 


  SELECT 
  PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3),
   PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
    PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
  FROM PortfolioProject. .NashvielleHousing

   alter table NashvielleHousing
  add OwnerSplitAddress Nvarchar(255);

  update NashvielleHousing
  set OwnerSplitAddress=   PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

    alter table NashvielleHousing
  add OwnerSplitCity Nvarchar(255);

  update NashvielleHousing
  set OwnerSplitCity =   PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

   alter table NashvielleHousing
  add OwnerSplitState Nvarchar(255);

  update NashvielleHousing
  set OwnerSplitState =  PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
   



  SELECT Distinct(SoldAsVacant), count(SoldAsVacant)
  FROM PortfolioProject. .NashvielleHousing
  group by SoldAsVacant
  order by 2


  
  SELECT SoldAsVacant,
  CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
       WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   end
  FROM PortfolioProject. .NashvielleHousing

  update NashvielleHousing
  SET SoldAsVacant =  CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
       WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   end

  


  --Remove Duplicates 
  with RowNumCTE AS(
  select *,
  ROW_NUMBER() over(
  partition by ParcelID,
               PropertyAddress,
			   SalePrice,
			   LegalReference
			   order by 
			   UniqueID
			   ) ROW_NUM
  from PortfolioProject. .NashvielleHousing
  --ORDER BY ParcelID
) 
SELECT *
FROM RowNumCTE
Where row_num > 1
order by PropertyAddress



--Delete unused columns 

select *
from PortfolioProject. .NashvielleHousing

alter table PortfolioProject. .NashvielleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress

alter table PortfolioProject. .NashvielleHousing
drop column SaleDate