import React, { Suspense } from 'react';
import EditUser from './EditUser';

export default function EditPage() {
  return (
    <Suspense fallback={<div>Loading...</div>}>
      <EditUser />
    </Suspense>
  );
}
