select * 
from [Portfolio Project]..coviddeaths
order by 3,4

--select * 
--from [Portfolio Project]..['covid vaccinations$']
--order by 3,4

--Select data that we are using

SELECT location, date, total_cases, new_cases, total_deaths, population
from [Portfolio Project]..coviddeaths
order by 1,2

--Working on total cases vs total deaths
--shows liklihood of dying if you contract covid in your country

select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from [Portfolio Project]..coviddeaths
where location like '%India%'
order by 1,2

--Looking at total cases vs population
--population that got covid

select location, date, total_cases,population, (total_cases/population)*100 as DeathPercentage
from [Portfolio Project]..coviddeaths
--where location like '%India%'
order by 1,2

--Looking at countries with higher infection rate compared to population

select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfcted
from [Portfolio Project]..coviddeaths
--where location like '%India%'
group by location,population
order by PercentPopulationInfcted desc

--Countries with highest death count per population
--Showing the continent with highest death count per population

select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from [Portfolio Project]..coviddeaths
--where location like '%India%'
where continent is not null
group by continent
order by TotalDeathCount desc

--Global Numbers

select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/SUM(new_cases)*100 as deathpercentage
from [Portfolio Project]..coviddeaths
--where location like '%India%
where continent is not null
group by date
order by 1,2

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int, vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated

from [Portfolio Project]..coviddeaths dea
join [Portfolio Project]..['covid vaccinations$'] vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3

--Use CTE

with popvsvac (continent, location, date, population, new_vaccinations,  rollingpeoplevaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int, vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated

from [Portfolio Project]..coviddeaths dea
join [Portfolio Project]..['covid vaccinations$'] vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select *, (rollingpeoplevaccinated/population)*100 from popvsvac