# antonLytkin18_infra
antonLytkin18 Infra repository

**Задание 1**. Для подключения к `someinternalhost` в одну строку, необходимо выполнить команду:

`$ ssh -t -i ~/.ssh/id_rsa -A anton_lytkin@104.199.59.234 ssh 10.132.0.3`

**Задание 1.1**. Для подключения к `someinternalhost` через alias, необходимо создать файл `~/.ssh/config` с содержимым:

```
Host bastion
    HostName 104.199.59.234
    User anton_lytkin

Host someinternalhost
    HostName 10.132.0.3
    User anton_lytkin
    ProxyCommand ssh anton_lytkin@104.199.59.234 nc %h %p 2> /dev/null
```

**Задание 2**. Файл `setupvpn.sh` устанавливает VPN-сервер `pritunl`.

Файл `cloud-bastion.ovpn` описывает конфигурацию для подключения к VPN-серверу.

**Задание 3**. Данные для проверки подключения:

```
bastion_IP = 104.199.59.234
someinternalhost_IP = 10.132.0.3
```