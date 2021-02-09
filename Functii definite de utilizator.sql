Use Firma2

--1. Scrieți și testați o funcție care returnează angajații a căror funcții conține o secvență de caractere primită ca parametru?

CREATE FUNCTION dbo.udfChecksecventa (@secventa varchar(6))
RETURNS TABLE 
as
RETURN Select A.nume, A.prenume from Angajati A
join Functii F on (A.IdFunctie=F.IdFunctie)
where denumire like '%'+@secventa+'%'

Select * from dbo.udfChecksecventa('EC')

--2. Scrieți și testați o funcție care returnează salariile dintr-un departament primit ca parametru? Câți angajați beneficiază de fiecare salariu?

CREATE FUNCTION dbo.udfSalariidept(@departament varchar(15))
RETURNS TABLE
as
Return Select F.Salariu, count(A.IdAngajat) as NrAngajati from Angajati A join Functii F on A.IdFunctie=F.IdFunctie
join Departamente D on A.IdDept=D.IdDept
where D.denumire=@departament
Group by F.Salariu

Select * from dbo.udfSalariidept('PROIECTARE')

--3. Scrieți și testați o funcție care returnează salariul minim și maxim dintr-un departament primit ca parametru?

CREATE FUNCTION dbo.udfSalMinMax(@departament varchar(15))
RETURNS TABLE
as 
Return Select Min(F.Salariu) as SalMin, Max(F.Salariu) as SalMax from Angajati A join Functii F on A.IdFunctie=F.IdFunctie
join Departamente D on D.IdDept=A.IdDept
where D.Denumire=@departament

Select * from dbo.udfSalMinMax('MANAGEMENT')

--4. Scrieți și testați o funcție care returnează produsele vândute într-o anumită perioadă de timp?
--	Limitele perioadei de timp sunt trimise ca parametri către funcție.

CREATE FUNCTION dbo.udfVanzTimp(@inf date, @sup date)
RETURNS TABLE
as
Return Select P.denumire from Vanzari V join Produse P on V.IdProdus=P.IdProdus
where V.DataVanz>@inf and V.DataVanz<@sup

Select * from dbo.udfVanzTimp('2016/05/20','2016/06/11')

--5. Scrieți și testați o funcție care returnează suma totală încasată de un vânzător al cărui nume este trimis ca parametru.

CREATE FUNCTION dbo.sumatotala(@name varchar(20), @surname varchar(20))
RETURNS decimal
as
BEGIN
		DECLARE @result decimal
		SELECT @result = SUM(V.PretVanz)
		FROM Angajati A join Vanzari V on V.IdVanzator=A.IdAngajat
		where A.nume=@name
		RETURN @result
END
Select dbo.sumatotala('N13', 'P9') SumaTotala

-- Scrieți si testați o funcție care se bazează pe prima și care verifică dacă suma depășește un anumit prag minim trimis ca parametru.

CREATE FUNCTION dbo.checksuma(@name varchar(20), @surname varchar(20), @prag decimal)
RETURNS bit
as 
BEGIN 
		DECLARE @suma decimal
		DECLARE @bit bit
		Select @suma=dbo.sumatotala(@name,@surname)
		if(@suma>@prag)
			set @bit = 1
			else set @bit = 0
		RETURN @bit
END

SELECT dbo.checksuma('N13','P9',153) as 'Value'

-- Afișați angajații care au vândut produse în valoare mai mare decât 100 RON.

SELECT nume, prenume from Angajati
where (Select dbo.checksuma(nume,prenume,100)) = 1

--6. Scrieți și testați o funcție care returnează cele mai vândute N produse, într-o anumită perioadă de timp.
-- Valoarea lui N și limitele perioadei de timp sunt trimise ca parametri către funcție.

CREATE FUNCTION dbo.udfmostsold(@N integer, @inf date, @sup date)
RETURNS TABLE
AS
RETURN
SELECT TOP (@N) P.Denumire, V.PretVanz from Vanzari V join Produse P on V.IdProdus=P.IdProdus
where V.DataVanz>@inf and V.DataVanz<@sup
ORDER BY V.PretVanz DESC

SELECT * FROM dbo.udfmostsold(4,'2015/05/20','2017/06/11')

--7. Scrieți și testați o funcție care returnează clienții ordonați descrescător după sumele cheltuite, într-o anumită perioadă de timp ale cărei limite sunt trimise ca parametri.

CREATE FUNCTION dbo.clientiordonati(@inf date, @sup date)
RETURNS TABLE
AS
RETURN
SELECT C.denumire, (SELECT SUM(PretVanz) from Vanzari V where IdClient=C.IdClient) as Total FROM CLIENTI C JOIN VANZARI V ON V.IdClient=C.IdClient
where V.DataVanz>@inf and V.DataVanz<@sup
GROUP BY C.denumire, C.IdClient
ORDER BY TOTAL DESC OFFSET 0 ROWS

SELECT * FROM dbo.clientiordonati('2015/05/20','2017/06/11')

