import React, { Suspense } from 'react';
import EditQuestion from './EditQuestion';

export default function EditQuestionPage() {
  return (
    <Suspense fallback={<div>Loading...</div>}>
      <EditQuestion />
    </Suspense>
  );
}
