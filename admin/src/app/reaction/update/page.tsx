'use client';

// import React, { useEffect, useState } from 'react';
import Image from 'next/image';
// import * as service from '@/lib/service';
// import * as entity from '@/lib/entity';

export default function UpdatePage() {
  return (
    <main className="wrapper">
      <h1>反応機構更新</h1>

      <p>
        なんとかなんとかかんとかなんとかかんとかなんとかかんとかなんとかかんとかなんとかかんとかなんとかかんとかなんとかかんとかなんとかかんとかなんとかかんとかなんとかかんとかかんとか
      </p>

      <form>
        <button
          type="button"
          className="reaction-edit-add-reaction-button"
          onClick={() => alert('hello')}
        >
          <Image src="/edit-reaction.svg" alt="" />
        </button>
      </form>
    </main>
  );
}
