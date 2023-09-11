﻿
&НаСервере
Процедура ПриОткрытииНаСервере()
	
	КонецЭтогоДня = КонецДня(ТекущаяДатаСеанса());
	НижняяГраницаНапоминаний = Константы.НижняяГраницаНапоминанийОСтатусахЗанятий.Получить();
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	СтатусыЗанятий.Занятие,
	                      |	СтатусыЗанятий.СтатусЗанятия
	                      |ПОМЕСТИТЬ ВТ_ПросроченныеЗанятия
	                      |ИЗ
	                      |	РегистрСведений.СтатусыЗанятий КАК СтатусыЗанятий
	                      |ГДЕ
	                      |	СтатусыЗанятий.Занятие.Дата < &ТекущаяДата
	                      |			И СтатусыЗанятий.Занятие.Дата > &НижняяГраница
	                      |	И СтатусыЗанятий.СтатусЗанятия <> ЗНАЧЕНИЕ(Перечисление.СтатусыЗанятий.Отменено)
	                      |	И СтатусыЗанятий.СтатусЗанятия <> ЗНАЧЕНИЕ(Перечисление.СтатусыЗанятий.Перенесено)
	                      |	И СтатусыЗанятий.СтатусЗанятия <> ЗНАЧЕНИЕ(Перечисление.СтатусыЗанятий.Проведено)
	                      |	И СтатусыЗанятий.СтатусЗанятия <> ЗНАЧЕНИЕ(Перечисление.СтатусыЗанятий.ПроведеноИОплачено)
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ЗанятияУроки.Обучающийся,
	                      |	ВТ_ПросроченныеЗанятия.Занятие,
	                      |	ВТ_ПросроченныеЗанятия.СтатусЗанятия КАК ТекущийСтатус,
	                      |	РАЗНОСТЬДАТ(ВТ_ПросроченныеЗанятия.Занятие.Дата, &ТекущаяДата, ДЕНЬ) КАК ДнейПросрочки,
	                      |	ЗанятияУроки.Ссылка.Дата
	                      |ИЗ
	                      |	ВТ_ПросроченныеЗанятия КАК ВТ_ПросроченныеЗанятия
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Занятия.Уроки КАК ЗанятияУроки
	                      |		ПО ВТ_ПросроченныеЗанятия.Занятие = ЗанятияУроки.Ссылка");
	
	Запрос.УстановитьПараметр("ТекущаяДата", КонецДня(ТекущаяДата()-86400));
	Запрос.УстановитьПараметр("НижняяГраница", НижняяГраницаНапоминаний);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НовСтр = СписокЗанятий.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр, Выборка);
		НовСтр.ДатаСтрока = Строка(Формат(Выборка.Дата,"ДФ='дддд, д ММММ, HH:mm'"));
	КонецЦикла;
	

	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПриОткрытииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура Отложить(Команда)
	ЭтаФорма.Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура СписокЗанятийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	текДанные = Элементы.СписокЗанятий.ТекущиеДанные;
	ПоказатьЗначение(, текДанные.Занятие);
КонецПроцедуры
