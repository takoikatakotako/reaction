type TextAreaInputFieldProps = {
  label: string;
  name: string;
  placeholder?: string;
  rows?: number;
  value: string;
  onChange: (e: React.ChangeEvent<HTMLTextAreaElement>) => void;
};

export default function TextAreaInputField({
  label,
  name,
  placeholder,
  rows = 6,
  value,
  onChange,
}: TextAreaInputFieldProps) {
  return (
    <div className="reaction-edit-content">
      <label htmlFor={name}>{label}</label>
      <textarea
        name={name}
        placeholder={placeholder}
        rows={rows}
        value={value}
        onChange={onChange}
        style={{ width: '100%', fontSize: '16px', padding: '8px' }}
      />
      <hr />
    </div>
  );
}
