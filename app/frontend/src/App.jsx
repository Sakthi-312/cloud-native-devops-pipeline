import React, { useEffect, useState } from 'react';

export default function App() {
  const [people, setPeople] = useState([]);
  const [name, setName] = useState('');
  const [role, setRole] = useState('student');

  const load = async () => {
    const res = await fetch('/api/people');
    setPeople(await res.json());
  };
  useEffect(() => { load(); }, []);

  const add = async () => {
    if (!name.trim()) return;
    await fetch('/api/people', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ name, role }),
    });
    setName('');
    load();
  };

  return (
    <div style={{ maxWidth: 520, margin: '40px auto', fontFamily: 'sans-serif' }}>
      <h1>Student-Teacher Portal After Edit and Push</h1>
      <input value={name} onChange={(e) => setName(e.target.value)} placeholder="Name" />
      <select value={role} onChange={(e) => setRole(e.target.value)}>
        <option value="student">Student</option>
        <option value="teacher">Teacher</option>
      </select>
      <button onClick={add}>Add</button>
      <ul>
        {people.map((p) => (<li key={p.id}>{p.name} ({p.role})</li>))}
      </ul>
    </div>
  );
}
