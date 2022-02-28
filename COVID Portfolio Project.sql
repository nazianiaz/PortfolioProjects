Select *
From PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

--Select *
--From PortfolioProject..CovidVaccinations
--order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
From PortfolioProject..CovidDeaths
where location like '%states%' and continent is not null
order by 1,2

Select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
where location like '%states%' and continent is not null
order by 1,2
--shows what percentage of people got Covid in States

Select location, population, MAX(total_cases) as Highest_Infection_Count, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
where continent is not null
--where location like '%states%'
Group by population, location
order by PercentPopulationInfected desc
--looking at countries with the Highest Infection Rates compared to Population

Select location, MAX(cast(total_deaths as int)) as Total_Death_Count 
From PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
Group by location
order by Total_Death_Count desc
--showing countries with the highest death count per population


Select location, MAX(cast(total_deaths as int)) as Total_Death_Count 
From PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is null  
Group by location
order by Total_Death_Count desc
--breaking the data down by world and continent

Select continent, MAX(cast(total_deaths as int)) as Total_Death_Count 
From PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null  
Group by continent
order by Total_Death_Count desc
--shows the continent with the highest death count per population

Select date, SUM(new_cases) as Total_Case_Per_Day, SUM(cast(new_deaths as int)) as Total_Deaths_Per_Day, SUM(cast(new_deaths as int))/SUM(new_cases)* 100 as Global_Death_Percentage
From PortfolioProject..CovidDeaths
--where location like '%states%' and 
where continent is not null
Group By date
order by 1,2
--global numbers

Select SUM(new_cases) as Total_Case_Per_Day, SUM(cast(new_deaths as int)) as Total_Deaths_Per_Day, SUM(cast(new_deaths as int))/SUM(new_cases)* 100 as Global_Death_Percentage
From PortfolioProject..CovidDeaths
--where location like '%states%' and 
where continent is not null
--Group By date
order by 1,2
--total cases and deaths globally

Select Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations, 
SUM(cast(Vac.new_vaccinations as bigint)) OVER (Partition by Dea.location order by Dea.location,Dea.date) as Rolling_Count_of_People_Vaccinated
From PortfolioProject..CovidDeaths Dea
Join PortfolioProject..CovidVaccinations Vac
 on Dea.location = Vac.location
 and Dea.date = Vac.date
 where Dea.continent is not null
 order by 2,3
 --looking at total population VS total vaccination

 --Use CTE
 With PopVSVac (Continent, Location, Date, Population, New_vaccinations, Rolling_Count_of_People_Vaccinated)
 as
 (
 Select Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations, 
SUM(cast(Vac.new_vaccinations as bigint)) OVER (Partition by Dea.location order by Dea.location,Dea.date) as Rolling_Count_of_People_Vaccinated
From PortfolioProject..CovidDeaths Dea
Join PortfolioProject..CovidVaccinations Vac
 on Dea.location = Vac.location
 and Dea.date = Vac.date
 where Dea.continent is not null
 --order by 2,3
)
Select *, (Rolling_Count_of_People_Vaccinated/Population)*100 As Percentage_of_Population_Vaccinated 
From PopVSVac
--Used a CTE to calculate the total Percentage of People vaccinated in every country

--Temp Table

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
Population numeric,
new_vaccinations numeric,
Rolling_Count_of_People_Vaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations, 
SUM(cast(Vac.new_vaccinations as bigint)) OVER (Partition by Dea.location order by Dea.location,Dea.date) as Rolling_Count_of_People_Vaccinated
From PortfolioProject..CovidDeaths Dea
Join PortfolioProject..CovidVaccinations Vac
 on Dea.location = Vac.location
 and Dea.date = Vac.date
 --where Dea.continent is not null
 --order by 2,3
 Select *, (Rolling_Count_of_People_Vaccinated/Population)*100 As Percentage_of_Population_Vaccinated 
From #PercentPopulationVaccinated

--Created a temp table to show the total number of people vaccinated for a given population

--Create Views

Create view PercentPopulationVaccinated as
Select Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations, 
SUM(cast(Vac.new_vaccinations as bigint)) OVER (Partition by Dea.location order by Dea.location,Dea.date) as Rolling_Count_of_People_Vaccinated
From PortfolioProject..CovidDeaths Dea
Join PortfolioProject..CovidVaccinations Vac
 on Dea.location = Vac.location
 and Dea.date = Vac.date
where Dea.continent is not null
--order by 2,3

Select *
From PercentPopulationVaccinated