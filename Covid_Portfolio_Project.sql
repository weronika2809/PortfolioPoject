use Covid_europe

select * from covid
order by 3, 4

select location, date, total_cases, new_cases, total_deaths, population
from covid
order by 1,2

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from covid
order by 1,2

select location, date, total_cases, population, (total_cases/population)*100 as PercentPopulationInfected
from covid
order by 1,2

select location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentPopulationInfected
from covid
group by location, population 
order by 1, 2

select location, max(total_deaths) as TotalDeathCount
from covid
group by location
order by TotalDeathCount desc

select date, sum(new_cases) as sum_cases, sum(new_deaths) as sum_deaths
from covid
group by date

select sum(new_cases) as sum_cases, sum(new_deaths) as sum_deaths, sum(new_deaths)/sum(new_cases)*100 as EuropeDeathPercentage
from covid


with popvsvac(location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
select c.location, c.date, c.population, cv.new_vaccinations, sum(cv.new_vaccinations) over (partition by c.location order by c.date)
as RollingPeopleVaccinated
from covid c
join covidvacc cv
on c.location=cv.location
and c.date=cv.date
)
select *, (RollingPeopleVaccinated/Population)*100
from popvsvac


create table #PercentPopulationVaccinated
(
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric,
)

insert into #PercentPopulationVaccinated
select c.location, c.date, c.population, cv.new_vaccinations, sum(cv.new_vaccinations) over (partition by c.location order by c.date)
as RollingPeopleVaccinated
from covid c
join covidvacc cv
on c.location=cv.location
and c.date=cv.date

select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated

create view PercentPopulationVaccinated as
select c.location, c.date, c.population, cv.new_vaccinations, sum(cv.new_vaccinations) over (partition by c.location order by c.date)
as RollingPeopleVaccinated
from covid c
join covidvacc cv
on c.location=cv.location
and c.date=cv.date
