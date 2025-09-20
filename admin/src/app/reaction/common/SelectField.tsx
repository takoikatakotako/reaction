import Image from 'next/image';

type SelectFieldProps = {
  label: string;
  name: string;
  options: string[];
  selectedValues: string[];
  onSelectionChange: (selectedValues: string[]) => void;
  onSelectionAdd: () => void;
  onSelectionDelete: (index: number) => void;
};

export default function SelectField({
  label,
  name,
  options,
  selectedValues,
  onSelectionChange,
  onSelectionAdd,
  onSelectionDelete,
}: SelectFieldProps) {
  const handleSelectChange = (e: React.ChangeEvent<HTMLSelectElement>, index: number) => {
    const newSelectedValues = [...selectedValues];
    newSelectedValues[index] = e.target.value;
    onSelectionChange(newSelectedValues);
  };

  return (
    <div className="reaction-edit-content">
      <label htmlFor={label}>{name}</label>

      {selectedValues.length !== 0 &&
        selectedValues.map((selectedValue, index) => (
          <div key={index}>
            <div className="reaction-edit-multi-input-container">
              <select
                name={`${label}-${index}`}
                value={selectedValue}
                onChange={(e) => handleSelectChange(e, index)}
                style={{
                  width: '100%',
                  padding: '8px',
                  fontSize: '16px',
                  border: '1px solid #ccc',
                  borderRadius: '4px',
                  backgroundColor: 'white'
                }}
              >
                <option value="">選択してください</option>
                {options.map((option) => (
                  <option key={option} value={option}>
                    {option}
                  </option>
                ))}
              </select>
              <button
                type="button"
                className="reaction-edit-image-delete-button"
                onClick={() => onSelectionDelete(index)}
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
        onClick={() => onSelectionAdd()}
      >
        <Image src="/plus.svg" alt="" width={140} height={40} />
      </button>
    </div>
  );
}