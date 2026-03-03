import fs from 'fs';
import path from 'path';

const DATA_FILE = path.join(process.cwd(), 'src/data/values.json');

export interface ValueItem {
  id: string;
  name: string;
  value: string;
}

export function getData(): ValueItem[] {
  try {
    const data = fs.readFileSync(DATA_FILE, 'utf8');
    return JSON.parse(data);
  } catch (error) {
    console.error('Error reading data:', error);
    return [];
  }
}

export function saveData(data: ValueItem[]): void {
  try {
    fs.writeFileSync(DATA_FILE, JSON.stringify(data, null, 2), 'utf8');
  } catch (error) {
    console.error('Error saving data:', error);
  }
}
