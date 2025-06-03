import Image from 'next/image';

type ImagesInputFieldProps = {
  label: string;
  name: string;
  imageURLs: string[];
  inputRef: React.RefObject<HTMLInputElement | null>;
  onImageChange: (e: React.ChangeEvent<HTMLInputElement>) => void;
  onImageDelete: (index: number) => void;
};

export default function ImagesInputField({
  label,
  name,
  imageURLs,
  inputRef,
  onImageChange,
  onImageDelete,
}: ImagesInputFieldProps) {
  return (
    <div className="reaction-edit-content">
      <label htmlFor={label}>{name}</label>
      <input
        type="file"
        accept="image/png"
        onChange={onImageChange}
        ref={inputRef}
      />

      {imageURLs.length === 0 && (
        <div className="reaction-edit-image-container">
          <Image
            className="reaction-edit-image"
            src="/image-placeholder.png"
            alt=""
            width={0}
            height={0}
          />
        </div>
      )}

      {imageURLs.length !== 0 &&
        imageURLs.map((url, index) => (
          <div key={index} className="reaction-edit-image-container">
            <Image
              className="reaction-edit-image"
              src={url}
              alt=""
              width={0}
              height={0}
            />
            <button
              type="button"
              className="reaction-edit-image-delete-button"
              onClick={() => onImageDelete(index)}
            >
              <Image src="/image-delete.svg" alt="" width={0} height={0} />
            </button>
          </div>
        ))}

      <hr />
    </div>
  );
}
