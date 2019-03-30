# antonLytkin18_infra
antonLytkin18 Infra repository

### Домашнее задание №3

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

**Задание 3.1**. Реализовано использование валидного сертификата с помощью сервиса `sslip.io`:

https://104.199.59.234.sslip.io

### Домашнее задание №4

1. Создание инстанса `redit-app` с автозапуском скрипта `startup.sh`:

```
$ gcloud compute instances create reddit-app \
    --zone="us-east1-b" \
    --boot-disk-size=10GB \
    --image-family ubuntu-1604-lts \
    --image-project=ubuntu-os-cloud \
    --machine-type=g1-small \
    --tags puma-server \
    --restart-on-failure \
    --metadata-from-file startup-script=startup.sh
```

2. Создание правила файрвола из командной строки: 

```       
$ gcloud compute firewall-rules create default-puma-server \
    --allow=tcp:9292 --direction=ingress \
    --source-ranges=0.0.0.0/0 \
    --target-tags=puma-server
```

3. Данные для проверки подключения:

```
testapp_IP = 35.229.62.122
testapp_port = 9292
```
