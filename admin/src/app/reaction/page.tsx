'use client';

// import Image from 'next/image';
import React, { useEffect, useState } from 'react';
import Link from 'next/link';
// import React, { useState, ChangeEvent, FormEvent } from 'react';

import { fetchReaction, Reaction } from '@/lib/api';

export default function AboutPage() {
  const [reactions, setReactions] = useState<Reaction[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const loadReaction = async () => {
      try {
        const reactions = await fetchReaction();
        setReactions(reactions);
      } catch (err) {
        // setError((err as Error).message);
      }
    };

    loadReaction();
  }, []);

  return (
    <main className="wrapper">
      <h1>反応機構一覧</h1>

      {reactions.map((reaction) => (
        <div className="reaction-content" key={reaction.id}>
          <Link href={`reaction/edit?id=${reaction.id}`}>
            <h2>ID: {reaction.id}</h2>
          </Link>
          <p>Name: {reaction.englishName}</p>
          <img src="acetoacetic-ester-synthesis-thumbnail.png" />
          <hr />
        </div>
      ))}

      <div>
        <ul className="pagination">
          <li className="pagination-active">
            <Link href="/reaction/new">+</Link>
          </li>
          <li className="pagination-active">
            <a href="user.html">1</a>
          </li>
          <li className="pagination-inactive">
            <a href="user.html">2</a>
          </li>
          <li className="pagination-inactive">
            <a href="user.html">3</a>
          </li>
          <li className="pagination-inactive">
            <a href="user.html">4</a>
          </li>
          <li className="pagination-inactive">
            <a href="user.html">5</a>
          </li>
          <li className="pagination-inactive">
            <a href="user.html">6</a>
          </li>
          <li className="pagination-inactive">
            <a href="user.html">7</a>
          </li>
          <li className="pagination-inactive">
            <a href="user.html">8</a>
          </li>
          <li className="pagination-inactive">
            <a href="user.html">9</a>
          </li>
          <li className="pagination-inactive">
            <a href="user.html">10</a>
          </li>
        </ul>
      </div>
    </main>
  );
}
