'use client';

// import React, { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import Image from 'next/image';
import * as service from '@/lib/service';
// import * as entity from '@/lib/entity';

export default function UpdatePage() {
  // Router
  const router = useRouter();


  // Submit
  const submitHandleChange = async () => {
    const result = window.confirm("反応機構を更新してよろしいですか?");
    if (result) {
      try {
        await service.generateReactions()
        alert('更新成功！');
        router.push('/');
      } catch (error) {
        alert(`エラーが発生しました:\n${error}`);
      }
    }
  };

  return (
    <main className="wrapper">
      <h1>反応機構更新</h1>

      <p>
        以下のボタンを押すと反応機構が更新されます。若干のタイムラグがあります。
      </p>

      <form>
        <button
          type="button"
          className="reaction-edit-add-reaction-button"
          onClick={() => submitHandleChange()}
        >
          <Image src="/edit-reaction.svg" alt="" width={200} height={60} />
        </button>
      </form>
    </main>
  );
}
