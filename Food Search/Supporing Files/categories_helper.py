import json

def getCategories(parent_category: str) -> [[]]:
  category_arr = []

  with open('categories.json', 'r') as categories_json:
    categories = json.load(categories_json)
    for category in categories:
      if parent_category in category['parents']:
        title = category['title']
        alias = category['alias']
        print('Title: ' + title)
        print('Alias: ' + alias)
        print('')
        category_arr.append([alias, title])

  return category_arr

def main():
  categories = getCategories(parent_category='restaurants')

  header = 'import Foundation\n\nenum Categories: String {\n'
  footer = '}\n'

  with open('Categories.swift', 'w+') as categories_file:
    categories_file.write(header)
    for category in categories:
      categories_file.write('\tcase ' + category[0] + " = \"" + category[1] + '\"\n')
    categories_file.write('\n\tvar alias: String {\n')
    categories_file.write('\t\tswitch self {\n')
    for category in categories:
      categories_file.write('\t\tcase .' + category[0] + ':\n')
      categories_file.write('\t\t\treturn \"' + category[0] + '\"\n')
    categories_file.write('\t\t}\n')
    categories_file.write('\t}\n')
    categories_file.write(footer)

if __name__ == '__main__':
  main()
