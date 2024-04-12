-- 5. Создать процедуру (на выходе: файл в репозитории dbo.usp_MakeFamilyPurchase в папке Procedure)
--    5.1 Входной параметр (@FamilySurName varchar(255)) одно из значений атрибута SurName таблицы dbo.Family
--    5.2 Процедура при вызове обновляет данные в таблицы dbo.Family в поле BudgetValue по логике
--       5.2.1 dbo.Family.BudgetValue - sum(dbo.Basket.Value), где dbo.Basket.Value покупки для переданной в процедуру семьи
--       5.2.2 При передаче несуществующего dbo.Family.SurName пользователю выдается ошибка, что такой семьи нет
create or alter procedure dbo.usp_MakeFamilyPurchase
    @FamilySurName varchar(255)
as
begin
    -- Проверяем существование семьи с заданной фамилией
    if not exists (select f.SurName from dbo.Family as f where f.SurName = @FamilySurName)
        raiserror('Семьи с такой фамилией в таблице Family не существует', 1, 1);
    -- Уменьшаем бюджет семьи на сумму её покупок
    with cte_TotalExpenses as (
        select
            ID_Family
            ,sum(b.Value) as Expenses
        from dbo.Basket as b
        group by ID_Family
    )
    update f
    set f.BudgetValue = f.BudgetValue - te.Expenses
    from dbo.Family as f
        inner join cte_TotalExpenses te on f.ID = te.ID_Family
    where f.SurName = @FamilySurName
end;