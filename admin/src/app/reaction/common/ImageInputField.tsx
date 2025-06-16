import Image from 'next/image';

type ImageInputFieldProps = {
  imageURL: string;
  inputRef: React.RefObject<HTMLInputElement | null>;
  onImageChange: (e: React.ChangeEvent<HTMLInputElement>) => void;
  onImageDelete: () => void;
};

export default function ImageInputField({
  imageURL,
  inputRef,
  onImageChange,
  onImageDelete,
}: ImageInputFieldProps) {
    const handleDrop = (e: React.DragEvent<HTMLDivElement>) => {
    e.preventDefault();
    if (e.dataTransfer.files && e.dataTransfer.files.length > 0) {
      const file = e.dataTransfer.files[0];
      const dt = new DataTransfer();
      dt.items.add(file);
      if (inputRef.current) {
        inputRef.current.files = dt.files;

        // 自前で onChange を発火
        const changeEvent = {
          target: inputRef.current,
        } as unknown as React.ChangeEvent<HTMLInputElement>;

        onImageChange(changeEvent);
      }
      e.dataTransfer.clearData();
    }
  };

  const handleDragOver = (e: React.DragEvent<HTMLDivElement>) => {
    e.preventDefault();
  };
  
  return (
    <div className="reaction-edit-content">
      <label htmlFor="thumbnail">Thumbnail</label>
      {imageURL === '' ? (
        <div className="reaction-edit-image-container">
          <Image
            className="reaction-edit-image"
            src="/image-placeholder.png"
            width={0}
            height={0}
            alt=""
            style={{ width: '404px', height: 'auto' }}
          />
        </div>
      ) : (
        <div className="reaction-edit-image-container">
          <Image
            className="reaction-edit-image"
            src={imageURL}
            width={0}
            height={0}
            alt=""
            style={{ width: '404px', height: 'auto' }}
          />
          <button
            type="button"
            className="reaction-edit-image-delete-button"
            onClick={onImageDelete}
          >
            <Image src="/image-delete.svg" alt="" width={0} height={0} />
          </button>
        </div>
      )}

      <input
        type="file"
        accept="image/png"
        onChange={onImageChange}
        ref={inputRef}
      />

      <div
        className="reaction-edit-image-dropzone"
        onDrop={handleDrop}
        onDragOver={handleDragOver}
        onClick={() => inputRef.current?.click()}
        style={{
          border: '2px dashed #ccc',
          padding: '16px',
          textAlign: 'center',
          cursor: 'pointer',
        }}
      >
        <p style={{ marginTop: '8px', color: '#666' }}>
          画像をドラッグ＆ドロップ、またはクリックしてアップロード
        </p>
      </div>

      <hr />
    </div>
  );
}
