'use client';

import React, { useState } from 'react';
import * as service from '@/lib/service';

export default function UpdatePage() {
  const [isExporting, setIsExporting] = useState(false);


  // S3 Export
  const handleExportToS3 = async () => {
    if (isExporting) return;

    const result = window.confirm("DynamoDBの値をS3にエクスポートしますか?");
    if (result) {
      setIsExporting(true);
      try {
        await service.exportToS3();
        alert('S3エクスポートが完了しました。');
      } catch (error) {
        alert(`S3エクスポートエラー:\n${error}`);
      } finally {
        setIsExporting(false);
      }
    }
  };

  return (
    <main className="wrapper">
      <h1>S3エクスポート</h1>

      <p>
        S3エクスポートボタンを押すと、DynamoDBの反応機構データをS3にエクスポートできます。
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
            {isExporting ? 'S3エクスポート中...' : 'S3エクスポート'}
          </div>
        </button>
      </form>
    </main>
  );
}
