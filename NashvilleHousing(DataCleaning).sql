/*

Cleaning Data in SQL Queries

*/


Select *
From PortfolioProject.dbo.NashvilleHousing

-----------------------------------------------------------------------------------------------------------------------

--Standardize Date Format


Select SaleDateConverted, Convert(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
Set SaleDate = Convert(Date,SaleDate)


--if it doesn't update properly

Alter Table NashvilleHousing
Add SaleDateConverted Date;


Update NashvilleHousing
Set SaleDateConverted = Convert(Date,SaleDate)


-----------------------------------------------------------------------------------------------------------------------


--Populate Property Address Data


Select *
From PortfolioProject.dbo.NashvilleHousing
--where propertyaddress is null
order by parcelid

Select a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress, isnull (a.propertyaddress, b.propertyaddress)
From PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
on a.parcelid = b.parcelid
and a.[uniqueid] <> b.[uniqueid]
where a.propertyaddress is null

Update a
Set propertyaddress = isnull (a.propertyaddress, b.propertyaddress)
From PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
on a.parcelid = b.parcelid
and a.[uniqueid] <> b.[uniqueid]
where a.propertyaddress is null


-----------------------------------------------------------------------------------------------------------------------


--Breaking out address into individual columns (Address,City, State)


Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);


Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);


Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


Select *
From PortfolioProject.dbo.NashvilleHousing


Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);


Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);


Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);


Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


Select *
From PortfolioProject.dbo.NashvilleHousing

-----------------------------------------------------------------------------------------------------------------------

--Change Y and N to Yes and No in 'Sold as Vacant' field


Select distinct(SoldAsVacant), count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2 desc


Select SoldAsVacant,
Case when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end
From PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
Set SoldAsVacant = Case when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end

-----------------------------------------------------------------------------------------------------------------------


--Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
				    ) row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID)
)
Select *
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress


Select *
From PortfolioProject.dbo.NashvilleHousing

-----------------------------------------------------------------------------------------------------------------------


--Delete Unused Columns
Select *
From PortfolioProject.dbo.NashvilleHousing

Alter Table PortfolioProject.dbo.NashvilleHousing
Drop Column OwnerAddress, TaxDistrict,PropertyAddress

Alter Table PortfolioProject.dbo.NashvilleHousing
Drop Column SaleDate,ownersplitaddress,ownersplitcity,ownersplitstate

Alter Table PortfolioProject.dbo.NashvilleHousing
Drop Column ownersplitaddress,ownersplitcity,ownersplitstate
