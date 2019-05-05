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

### Домашнее задание №5

1. Для запуска сборки образа, необходимо выполнить команду:

`$ packer build -var-file variables.json ubuntu16.json`

2. Для запуска сборки образа `reddit-full` с установленным приложением и автозапуском сервера, необходимо выполнить команду:

`$ packer build immutable.json`

3. Для создания инстанса c образом `reddit-full`, необходимо выполнить команду:

`$ ./config-scripts/create-reddit-vm.sh`

### Домашнее задание №6

1.1 Задание со (*). Для добавления ssh-ключей для нескольких пользователей, необходимо прописать внутри описания конкретного инстанса:

```
metadata {
   ssh-keys = "appuser:${file(var.public_key_path)}appuser1:${file(var.public_key_path)}appuser2:${file(var.public_key_path)}"
}
```

1.2 Задание со (*). При добавлении ssh-ключа для пользователя `appuser_web` и последующем выполнении команды
`terraform apply` произойдет удаление этого ключа, поскольку его добавление было произведено через веб-интерфейс GCP.
Для решения проблемы необходимо описать добавление данного ключа в файле `main.tf`.

2.1 Задание с (**). В файле `lb.tf` было описано создание [HTTP-балансировщика](https://cloud.google.com/load-balancing/docs/https/).

2.2 Задание с (**). Добавление нового инстанса увеличивает количество повторяющегося кода. Для решения этой проблемы
необходмо использовать переменную `count` внутри описания инстанса:

```
resource "google_compute_instance" "app" {
  name         = "reddit-app${count.index}"
  count        = "${var.count}"
}
```
### Домашнее задание №7

1. Создан модуль `vpc`, принимающий на входе параметр `source_ranges`, хранящий список допустимых
IP-адресов, с которых может производиться подключение к ВМ по `ssh`.
2. Созданы окружения `stage` и `prod`, отличия которых заключается в ограничении доступа по `ssh` с определенного IP-адреса
для окружения `prod`.
3. В каждом из окружений настроено удаленное хранение `state-файла` в `Google Cloud Storage`.
4. Добавлен запуск необходимых процедур в модули:
- `app`. Добавление переменной окружения `DATABASE_URL`, хранящей внутренний IP-адрес ВМ с `mongoDb` в `puma.env`:
 ````
provisioner "remote-exec" {
    inline = [
        "sudo echo DATABASE_URL=${var.db_ip} > /tmp/puma.env",
    ]
}
 ````
- `db`. Возможность подключения к `mongoDb` с любого IP:
````
provisioner "remote-exec" {
    inline = [
        "sudo sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' /etc/mongod.conf",
        "sudo systemctl restart mongod",
    ]
} 
````
