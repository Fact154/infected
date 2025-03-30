import os
from bs4 import BeautifulSoup
import re

def clean_svg(file_path):
    print(f"Processing {file_path}...")
    
    # Читаем SVG файл
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()
    
    # Парсим SVG
    soup = BeautifulSoup(content, 'xml')
    
    # Удаляем все элементы <style>
    for style in soup.find_all('style'):
        style.decompose()
    
    # Удаляем все ссылки на внешние стили
    for element in soup.find_all(lambda tag: tag.get('style')):
        del element['style']
    
    # Удаляем все классы
    for element in soup.find_all(lambda tag: tag.get('class')):
        del element['class']
    
    # Оптимизируем viewBox если его нет
    svg = soup.find('svg')
    if not svg.get('viewBox'):
        width = svg.get('width', '100')
        height = svg.get('height', '150')
        width = re.sub(r'[^0-9.]', '', width)
        height = re.sub(r'[^0-9.]', '', height)
        svg['viewBox'] = f"0 0 {width} {height}"
    
    # Добавляем width и height если их нет
    if not svg.get('width'):
        svg['width'] = '100%'
    if not svg.get('height'):
        svg['height'] = '100%'
    
    # Сохраняем очищенный SVG
    cleaned_content = str(soup)
    with open(file_path, 'w', encoding='utf-8') as file:
        file.write(cleaned_content)
    
    print(f"Cleaned {file_path}")

def main():
    # Путь к папке с SVG файлами
    svg_dir = os.path.join('assets', 'cards')
    
    # Проверяем существование директории
    if not os.path.exists(svg_dir):
        print(f"Directory {svg_dir} not found!")
        return
    
    # Обрабатываем все SVG файлы
    for filename in os.listdir(svg_dir):
        if filename.endswith('.svg'):
            file_path = os.path.join(svg_dir, filename)
            clean_svg(file_path)

if __name__ == '__main__':
    main() 