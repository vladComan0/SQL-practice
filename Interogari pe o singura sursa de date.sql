Use Firma2
GO

-- Media salariilor pe un departament specificat prin denumire

Select AVG(Salariu) SalMed
from vAngajati
where Departament='PRODUCTIE'
GO

-- Mediile salariilor grupate pe functii

Select Functie, AVG(Salariu) SalMed
from vAngajati
Group by functie
GO

-- Cel mai mic si cel mai mare salariu din companie

Select Min(Salariu) SalariuMinim, Max(Salariu) SalariuMaxim
from vAngajati

-- Cel mai mic si cel mai mare salariu dintr-un departament specificat

Select Min(Salariu) SalariuMinim, Max(Salariu) SalariuMaxim
from vAngajati
where Departament='Productie'

-- Cele mai mici si cele mai mari salarii pe departamente

Select Departament, Min(Salariu) SalariuMinim, Max(Salariu) SalariuMaxim
from vAngajati
Group by Departament

-- Numarul de angajati din fiecare departament

Select departament, count(*) as NumarAngajati
from vAngajati
Group by Departament

-- Suma salariilor angajatilor din fiecare departament

Select departament, sum(salariu) as SumaSalarii
from vAngajati
Group by Departament

-- Angajatii grupati pe departamente sortati dupa vechimi rotunjite la ani

Select Nume, Prenume, Departament, DateDiff(year, DataAngajarii, getDate()) as Vechime
from vAngajati
Group by Departament, Nume, Prenume, DataAngajarii
Order by Vechime

-- Angajatii grupati pe functii ce au o vechime mai mare de 10 ani

Select Nume, Prenume, Functie, DateDiff(year, DataAngajarii, getDate()) as Vechime -- optional cap de tabel vechime si altele
from vAngajati
where DateDiff(year, DataAngajarii, getDate())>10
Group by Functie, Nume, Prenume, DataAngajarii

-- Angajatii grupati pe departamente ce au varsta de minim 30 de ani

Select Nume, Prenume, Departament, DateDiff(year, DataNasterii, getDate()) as Varsta -- optional varsta si altele...
from vAngajati where DateDiff(year, DataNasterii, getDate())>=30
Group by Departament, Nume, Prenume, DataNasterii

-- Departamentele ce au media salariilor mai mare ca 3000

Select Departament, AVG(Salariu) as 'Salariu Mediu'
from vAngajati
Group by Departament
having AVG(Salariu)>5000
