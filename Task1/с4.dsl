workspace "Медикаменте" {

    !identifiers hierarchical

    model {
        
        properties {
            "structurizr.groupSeparator" "/"
        }
        
        
        analytic = person "Аналитик"
        
        user = person "Пользователь"
        
        group "Platform" {
        
            dwh = softwareSystem "DWH" {
                tags "Legacy"
            }
            
            powerbi = softwareSystem "Power BI" 
    
            powerbuilder = softwareSystem "Power Builder" {
                tags "Legacy"
            }
    
            clinics = softwareSystem "Внутренние сервисы"
            fintech = softwareSystem "Финтех-сервисы"
            ai = softwareSystem "ИИ-сервисы"
        
            dremio = softwareSystem "Dremio"
            
            nessie = softwareSystem "Nessie"
            
            iceberg = softwareSystem "Apache Iceberg"
            
            airflow = softwareSystem "Airflow" {
                tags "Queue"
            }
            
            minio = softwareSystem "MinIO" {
                tags "Database"
            }
            
            datahub = softwareSystem "Datahub"
        }
        
        analytic -> dremio "Аналитические запросы"
        
        user -> datahub "Работа с API"
        
        
        clinics -> airflow
        fintech -> airflow
        ai -> airflow
            
        
        dremio -> nessie "Определяет, с какой веткой данных работать"
        dremio -> iceberg "Читает таблицы, выполняет SQL-запросы"
        dremio -> minio "Чтение файлов Parquet"
        
        nessie -> iceberg "Управляет ветками, коммитами, snapshot-версией таблиц"
        
        dwh -> airflow "Исторические данные"
        powerbuilder -> dwh "Отчёты на старом UI"
        powerbi -> dwh "Отчёты на старом источнике (до миграции)"
        powerbi -> dremio "Отчеты на новой витрине"
        
        airflow -> minio
        airflow -> iceberg "Создаёт таблицы через Spark/Trino"
        
        datahub -> dremio "Получение схем и датасетов"
        
        iceberg -> minio "Сохраняет файлы таблиц (Parquet)"
    }
    
    views {
        systemLandscape main "auto" {
            include *
        }
        
        styles {
            element "Element" {
                background #008cba
                color #ffffff
                shape RoundedBox
            }
            element "Legacy" {
                background #8d99ae
                shape RoundedBox
            }
            element "Person" {
                background #05527d
                shape person
            }
            element "Software System" {
                background #066296
            }
            element "Database" {
                shape cylinder
            }
            element "Queue" {
                shape pipe
            }
            relationship "Relationship" {
                style solid
                routing Curved
            }
        }
    }

}
