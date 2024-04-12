-- 6. Создать триггер (на выходе: файл в репозитории dbo.TR_Basket_insert_update в папке Trigger)
--    6.1 Если в таблицу dbo.Basket за раз добавляются 2 и более записей одного ID_SKU, то значение в поле DiscountValue, для этого ID_SKU рассчитывается по формуле Value * 5%, иначе DiscountValue = 0
create or alter trigger dbo.tr_Basket_insert_update on dbo.Basket
after insert
as
begin
    with cte_UniqueCounts as (
        select
            ID_SKU
            ,count(ID_SKU) as NumInserted
        from inserted
        group by ID_SKU
    )
    update b
    set DiscountValue =
        case
            when uc.NumInserted < 2
                then 0
            when uc.NumInserted >= 2
                then cast(i.Value as float) * 0.05
        end
    from dbo.Basket b
    inner join inserted i on i.ID = b.ID
    inner join cte_UniqueCounts as uc on i.ID_SKU = uc.ID_SKU
end;