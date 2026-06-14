if [ -z "$1" ]; then
    echo "Использование: ./run.sh [команда]"
    echo "Доступные команды: build_generator, run_generator, create_local_data, build_reporter, run_reporter, structure, clear_data, inside_generator, inside_reporter"
    exit 1
fi

case "$1" in
    build_generator)
        echo "Сборка образа генератора"
        docker build -t hw3-generator ./generator
        ;;
        
    run_generator)
        echo "Запуск контейнера генератора"
        mkdir -p data
        docker run --rm -v "$(pwd)/data:/data" hw3-generator
        ;;
        
    create_local_data)
        echo "Генерация данныз локально без докера"
        mkdir -p local_data
        python3 generator/generate.py "$(pwd)/local_data"
        ;;
        
    build_reporter)
        echo "Сборка образа аналитика"
        docker build -t hw3-reporter ./reporter
        ;;
        
    run_reporter)
        echo "Запуск контейнера аналитика"
        if [ ! -f "data/data.csv" ]; then
            echo "Ошибка: Файл data/data.csv не найден! Сначала запустите ./run.sh run_generator"
            exit 1
        fi
        docker run --rm -v "$(pwd)/data:/data" hw3-reporter
        ;;
        
    structure)
        echo "Вывод структура проекта"
        if command -v tree &> /dev/null; then
            tree . -I 'node_modules'
        else
            find . -not -path '*/.*' -not -path './node_modules*'
        fi
        ;;
        
    clear_data)
        echo "Очистка всех данных"
        rm -f data/*.csv data/*.html
        echo "Папка data/ очищена."
        ;;
        
    inside_generator)
        echo "Вывод папки /data внутри генератора"
        docker run --rm -v "$(pwd)/data:/data" hw3-generator ls -la /data
        ;;
        
    inside_reporter)
        echo "Вывод папки /data внутри аналитика"
        docker run --rm -v "$(pwd)/data:/data" hw3-reporter ls -la /data
        ;;
        
    report_server)
        echo "Запуск веб-сервера для просмотра отчета"
        if [ ! -f "data/report.html" ]; then
            echo "Сначала сгенерируйте отчет через run_reporter"
            exit 1
        fi
        
        docker stop hw3-web-server &>/dev/null || true
        
        docker run -d --name hw3-web-server -v "$(pwd)/data:/usr/share/nginx/html" -p 8080:80 nginx:alpine
        
        echo "Контейнер запущен, отчет доступен во вкладке PORTS в Codespaces"
        ;;

    *)
        echo "Неизвестная команда: $1"
        exit 1
        ;;
esac