import React, { Suspense } from 'react';
import EditNotice from './EditNotice';

export default function EditNoticePage() {
  return (
    <Suspense fallback={<div>Loading...</div>}>
      <EditNotice />
    </Suspense>
  );
}
