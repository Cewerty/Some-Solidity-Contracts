## app.sol

Просто работа с различными типами данных в языке смарт-контрактов Soldity

## counter.sol

Простой смарт-контракт счетчик на Solidity со следующими функциями:
- Получить значение счетчика
- Увеличить значение счетчика на один
- Уменьшить значение счетчика на один
- Установить максимальное значение счетчика
- Установить минимальное значение счетчика

## storage.sol

Смарт-контракт хранилище, кооторый хранит в себе дважды хэшированные алгоритмом sha256 значения в mapping, где ключами выступают дважды хэшированные адреса пользователей.

Имеет обладает следующими функциями:
- Хэширование адреса пользователя
- Хэширование отправляемого значения
- Сохранение хэшированного значения в хэш-мапе
- Получение хэшированного значения из хэш-мапы
- Изменение хэшированного значения в хэш-мапе
- Удаление хэшированного значения в хэш-мапе

## wallet.sol 

Мой магнум опус, на данный момент, простейший криптокошелёк, который содержит следующие функции:
- Получение информации о кошельке пользователя
- Внесение денег на депозит
- Вывод денег с аккаунта
- Отправка денег на другой кошелёк
- Отправка определенной суммы нескольким пользователям