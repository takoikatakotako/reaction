import Image from 'next/image';

type TextsInputFieldProps = {
  label: string;
  name: string;
  texts: string[];
  onTextsChange: (
    e: React.ChangeEvent<HTMLInputElement>,
    index: number
  ) => void;
  onTextsDelete: (index: number) => void;
  onTextsAdd: () => void;
};

export default function TextsInputField({
  label,
  name,
  texts,
  onTextsChange,
  onTextsDelete,
  onTextsAdd,
}: TextsInputFieldProps) {
  return (
    <div className="reaction-edit-content">
      <label htmlFor={label}>{name}</label>

      {texts.length !== 0 &&
        texts.map((text, index) => (
          <div key={index}>
            <div className="reaction-edit-multi-input-container">
              <input
                type="text"
                name="englishName"
                value={text}
                placeholder="サジェスチョンの単語を入力"
                onChange={(e) => onTextsChange(e, index)}
              />
              <button
                type="button"
                className="reaction-edit-image-delete-button"
                onClick={() => onTextsDelete(index)}
              >
                <Image src="/image-delete.svg" alt="" width={20} height={20} />
              </button>
            </div>
            <hr />
          </div>
        ))}

      <button
        type="button"
        className="reaction-edit-multi-input-plus-button"
        onClick={() => onTextsAdd()}
      >
        <Image src="/plus.svg" alt="" width={140} height={40} />
      </button>
    </div>
  );
}
