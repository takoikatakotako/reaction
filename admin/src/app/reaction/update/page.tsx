'use client';

import React, { useState } from 'react';
import * as service from '@/lib/service';

export default function UpdatePage() {
  const [isExporting, setIsExporting] = useState(false);


  // S3 Export
  const handleExportToS3 = async () => {
    if (isExporting) return;

    const result = window.confirm("反応機構データを更新しますか?");
    if (result) {
      setIsExporting(true);
      try {
        await service.exportToS3();
        alert('データ更新が完了しました。');
      } catch (error) {
        alert(`データ更新エラー:\n${error}`);
      } finally {
        setIsExporting(false);
      }
    }
  };

  return (
    <main className="wrapper">
      <h1>データ更新</h1>

      <p>
        更新ボタンを押すと、反応機構データが更新されます。
      </p>

      <form>
        <button
          type="button"
          className="reaction-edit-add-reaction-button"
          onClick={() => handleExportToS3()}
          disabled={isExporting}
          style={{
            opacity: isExporting ? 0.6 : 1,
            cursor: isExporting ? 'not-allowed' : 'pointer'
          }}
        >
          <div style={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            backgroundColor: '#007bff',
            color: 'white',
            padding: '15px 30px',
            borderRadius: '5px',
            fontSize: '16px',
            fontWeight: 'bold'
          }}>
            {isExporting ? '更新中...' : 'データ更新'}
          </div>
        </button>
      </form>
    </main>
  );
}
