-- 3. Создать функцию (на выходе: файл в репозитории dbo.udf_GetSKUPrice.sql в папке Function)
--    3.1 Входной параметр @ID_SKU
--    3.2 Рассчитывает стоимость передаваемого продукта из таблицы dbo.Basket по формуле
--       3.1.1 сумма Value по переданному SKU / сумма Quantity по переданному SKU
--    3.3 На выходе значение типа decimal(18, 2)
create or alter function dbo.udf_GetSKUPrice (
    @ID_SKU int
)
returns decimal(18,2)
as
begin
    declare @SKUPrice decimal(18,2);
    select @SKUPrice = cast(sum(b.Value) as float)/sum(b.Quantity)
    from dbo.Basket as b
    where b.ID_SKU = @ID_SKU
    return @SKUPrice;
end;