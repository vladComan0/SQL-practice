use Firma2;
GO

-- 1.Care sunt angajații a căror funcții conține secvența de caractere ‘ngi’ ?
Select A.nume, A.prenume, F.denumire
from Angajati A JOIN Functii F
	on (A.IdFunctie=F.IdFunctie)
where F.denumire like '%ngi%'
GO

-- 2.Care sunt salariile din departamentul ‘PRODUCTIE’ și câți angajați au aceste salarii ?
Select F.salariu, count(A.IdAngajat) as NrAngajati
from Angajati A 
join Functii F on (A.IdFunctie=F.IdFunctie)
join Departamente D on (A.IdDept=D.IdDept)
where D.denumire='PRODUCTIE'
Group by F.salariu
go

-- 3.Care sunt cele mai mici/mari salarii din departamente ?
Select Min(F.salariu) as SalMin, Max(F.salariu) as SalMax
from Angajati A 
join Functii F on (A.IdFunctie=F.IdFunctie)
join Departamente D on (A.IdDept=D.IdDept)
go 

-- 4.Care sunt produsele vândute într-o anumită perioadă de timp ?
Select P.Denumire, V.DataVanz from Produse P
join Vanzari V on (P.IdProdus=V.IdProdus)
where DateDiff(day,V.DataVanz,getDate()) < DateDiff(day,'2016/05/01',getDate()) --Sau in loc de getDate o alta data specificata
go

-- 5.Care sunt clienții ce au cumpărat produse prin intermediul unui vânzător anume ?
Select C.Denumire from Vanzari V
join Clienti C on (C.IdClient=V.IdClient)
join Angajati A on (A.IdAngajat=V.IdVanzator)
where A.Nume = 'N13' and A.Prenume = 'P9'
go

-- 6.Care sunt clienții ce au cumpărat două produse ?
Select C.Denumire from Vanzari V
join Clienti C on (C.IdClient=V.IdClient)
where V.NrProduse = 2
go

-- 7.Care sunt clienții ce au cumpărat cel puțin două produse ?
Select C.Denumire from Vanzari V
join Clienti C on (C.IdClient=V.IdClient)
where V.NrProduse >=2
go

-- 8.Câți clienți au cumpărat (la o singură cumpărare) produse în valoare mai mare decât o sumă dată (de ex. 200) ?
Select count(C.IdClient) As NrClienti from Vanzari V
join Clienti C on (C.IdClient=V.IdClient)
where V.PretVanz>30
go

-- 9.Care sunt clienții din CLUJ care au cumpărat produse în valoare mai mare de 200 ?
Select C.Denumire from Vanzari V
join Clienti C on (C.IdClient=V.IdClient)
where V.PretVanz>15 and C.Adresa_jud='Cluj'
group by C.denumire
go

-- 10.Care sunt mediile vânzărilor pe o anumită perioadă de timp, grupate pe produse ?
Select AVG(V.PretVanz) as Medie_Vanzari, P.Denumire from Vanzari V
join Produse P on (V.IdProdus=P.IdProdus)
where DateDiff(day,V.DataVanz,getDate()) < DateDiff(day,'2016/05/01',getDate()) --Sau in loc de getDate o alta data specificata
group by P.Denumire
go

-- 11.Care este numărul total de produse vândute pe o anumită perioadă de timp ?
Select Sum(V.NrProduse) as 'Total Produse Vandute' from Vanzari V
where DateDiff(day,V.DataVanz,getDate()) < DateDiff(day,'2016/05/01',getDate()) --Sau in loc de getDate o alta data specificata
go

-- 12.Care este numărul de total de produse vândute de un vânzător precizat prin nume ?
Select Sum(V.NrProduse) as 'Total Produse Vandute', A.Nume, A.Prenume from Vanzari V
join Angajati A on (V.IdVanzator=A.IdAngajat)
where A.Nume='N13' and A.Prenume='P9'
group by A.Nume, A.Prenume
go

-- 13.Care sunt clienții ce au cumpărat produse în valoare mai mare decât media vânzărilor din luna august 2016 ?
Select C.Denumire from Vanzari V
join Clienti C on (V.IdClient=C.IdClient)
group by  C.Denumire, V.PretVanz, V.DataVanz
having V.PretVanz > (Select Avg(V.PretVanz) from Vanzari V where  (month(V.DataVanz) = 8 and year(V.DataVanz) = 2016))
go

-- 14.Care sunt produsele care s-au vândut la mai mult de un client ?
Select P.Denumire from Vanzari V
join Clienti C on (V.IdClient=C.IdClient)
join Produse P on (V.IdProdus=P.IdProdus)
where (Select count(V.IdClient) from Vanzari V where V.IdProdus=P.IdProdus)>=2
group by P.Denumire
go

-- 15.Care sunt vânzările valorice realizate de fiecare vânzător, grupate pe produse și clienți, cu subtotaluri ?

Select A.Nume, A.Prenume, V.PretVanz as Valoare, V.NrProduse as Cantitate, (Select Sum(PretVanz) from Vanzari join Angajati on (Vanzari.IdVanzator=Angajati.IdAngajat) where Angajati.nume=A.nume) as Subtotal from Vanzari V
join Clienti C on (C.IdClient=V.IdClient)
join Angajati A on (A.IdAngajat=V.IdVanzator)
join Produse P on (P.IdProdus=V.IdProdus)
group by A.Nume, A.Prenume, P.Denumire, C.Denumire, V.PretVanz, V.NrProduse

use Firma2
-- Care sunt angajații a căror funcții conține secvența de caractere ‘ngi’ ?
Select Nume, Prenume, Denumire
from Angajati A join Functii F on (A.IdFunctie=F.IdFunctie)
where Denumire like '%ngi%'

-- Care sunt vânzările valorice realizate de fiecare vânzător, grupate pe produse și clienți, cu subtotaluri ?


