import { NextResponse } from 'next/server';
import { getData, saveData, ValueItem } from '@/lib/data';

const API_KEY = "vtools-secret-key";

function checkAuth(request: Request) {
  const authHeader = request.headers.get('x-api-key');
  return authHeader === API_KEY;
}

export async function GET(request: Request) {
  if (!checkAuth(request)) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }
  const data = getData();
  return NextResponse.json(data);
}

export async function POST(request: Request) {
  if (!checkAuth(request)) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }
  try {
    const newItem: Omit<ValueItem, 'id'> = await request.json();
    const data = getData();

    const id = Math.random().toString(36).substring(2, 9);
    const item: ValueItem = { ...newItem, id };

    data.push(item);
    saveData(data);

    return NextResponse.json(item, { status: 201 });
  } catch {
    return NextResponse.json({ error: 'Invalid data' }, { status: 400 });
  }
}

export async function DELETE(request: Request) {
  if (!checkAuth(request)) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }
  try {
    const { id } = await request.json();
    let data = getData();
    data = data.filter(item => item.id !== id);
    saveData(data);
    return NextResponse.json({ success: true });
  } catch {
    return NextResponse.json({ error: 'Invalid request' }, { status: 400 });
  }
}
