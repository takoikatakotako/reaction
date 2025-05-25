'use client';

import React, { useEffect, useState } from 'react';
import Link from 'next/link';
import * as service from '@/lib/service';
import * as entity from '@/lib/entity';

export default function UpdatePage() {
  const [reactions, setReactions] = useState<entity.Reaction[]>([]);
  const [loading, setLoading] = useState(true);


  return (
    <main className="wrapper">
      <h1>反応機構更新</h1>

      <p>なんとかなんとかかんとかなんとかかんとかなんとかかんとかなんとかかんとかなんとかかんとかなんとかかんとかなんとかかんとかなんとかかんとかなんとかかんとかなんとかかんとかかんとか</p>

      <form>
          <button
            type="button"
            className="reaction-edit-add-reaction-button"
            onClick={() => alert("hello")}
          >
            <img src="/edit-reaction.svg" />
          </button>
      </form>
    </main>
  );
}
