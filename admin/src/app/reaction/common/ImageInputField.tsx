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
  return (
    <div className="reaction-edit-content">
      <label htmlFor="thumbnail">Thumbnail</label>
      <input
        type="file"
        accept="image/png"
        onChange={onImageChange}
        ref={inputRef}
      />

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
      <hr />
    </div>
  );
}
