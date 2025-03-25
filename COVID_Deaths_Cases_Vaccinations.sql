Select *
From PortfolioProject..COVIDDEATHS
ORDER BY 3,4

-- Select *
-- From PortfolioProject..COVIDVaccinations
-- ORDER BY 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..COVIDDEATHS
ORDER BY 1,2

--Let's look at Total Cases vs Total Deaths (Afghanistan)
SELECT location, date, total_cases, total_deaths,  
CASE WHEN total_cases = 0 THEN NULL ELSE (total_deaths / total_cases) * 100 END Death_Percentage
From PortfolioProject..COVIDDEATHS
WHERE location like '%afghanistan%'
ORDER BY 1,2

-- Total covid cases in Afghanistan as of today = 235,214 while total deaths stands at 7,998 so the Death Percentage as of today stands at 3.4%

-- We look at Total Cases vs Population (Brazil)
SELECT location, date, Population, total_cases, (total_cases / Population) * 100 AS Case_Percentage
From PortfolioProject..COVIDDEATHS
WHERE location like '%brazil%'
ORDER BY 1,2

--Total Cases to Population reached 10% on 10.10.2021 in Brazil

--We look at countries with the highest infection rate compared to population
SELECT location, population, MAX(total_cases) AS Highest_Infection_Count, MAX((total_cases/population)) * 100 AS Population_Infected_Percentage
FROM PortfolioProject..COVIDDEATHS
WHERE continent is not null
GROUP BY location, population
ORDER BY Population_Infected_Percentage ASC

--Showing Countries with the Highest Death Count per Population
SELECT location, MAX(total_deaths) AS Total_Death_Count
FROM PortfolioProject..COVIDDEATHS
WHERE continent is not null
GROUP BY location
ORDER BY Total_Death_Count DESC

--Breaking it up per continent]
SELECT continent, MAX(total_deaths) AS Total_Death_Count
FROM PortfolioProject..COVIDDEATHS
WHERE continent is not null
GROUP BY continent
ORDER BY Total_Death_Count DESC

--GLOBAL NUMBERS
SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, --total_cases, total_deaths,
CASE WHEN SUM(new_cases) = 0 THEN NULL ELSE (SUM(new_deaths)/SUM(new_cases))*100 END Death_Percentage
FROM PortfolioProject..COVIDDEATHS
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2

--Total COVID Cases = 85659396 Cases, Total COVID Deaths = 1137450, therefore COVID deaths are at a rate of 1.328%

--JOIN COVID DEATHS and VACCINATION TABLES (Looking at Total Population vs Vaccinations)
WITH PopvsVac (conntinent, location, date, population, new_vaccinations, Rolling_People_Vaccinated)
AS
(
SELECT DEA.continent, DEA.location, DEA.date, DEA.population, VAC.new_vaccinations,
SUM (CAST(VAC.new_vaccinations AS INT)) OVER (Partition by DEA.location ORDER BY DEA.location,
DEA.date) AS Rolling_People_Vaccinated
FROM PortfolioProject..COVIDDEATHS AS DEA
JOIN PortfolioProject..COVIDVACCINATIONS AS VAC
ON DEA.location = VAC.location AND DEA.date = VAC.date
WHERE DEA.continent is not null
--ORDER BY 2,3
)
SELECT *, (Rolling_People_Vaccinated/population)*100 AS Vaccinated_Percentage
FROM PopvsVac
ORDER BY 2,3

--As of 23/06/2021 the percentange of people vaccinated in Albania stood at49.88

--Creating View to Store Data for Later Visualisation
CREATE VIEW Percentage_Population_Vaccinated AS
SELECT DEA.continent, DEA.location, DEA.date, DEA.population, VAC.new_vaccinations,
SUM (CAST(VAC.new_vaccinations AS INT)) OVER (Partition by DEA.location ORDER BY DEA.location,
DEA.date) AS Rolling_People_Vaccinated
FROM PortfolioProject..COVIDDEATHS AS DEA
JOIN PortfolioProject..COVIDVACCINATIONS AS VAC
ON DEA.location = VAC.location AND DEA.date = VAC.date
WHERE DEA.continent is not null
--ORDER BY 2,3

SELECT *
FROM Percentage_Population_Vaccinated
ORDER BY 2,3




