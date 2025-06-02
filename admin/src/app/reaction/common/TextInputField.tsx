type TextInputFieldProps = {
  label: string;
  name: string;
  placeholder?: string;
  value: string;
  onChange: (e: React.ChangeEvent<HTMLInputElement>) => void;
};

export default function TextInputField({
  label,
  name,
  placeholder,
  value,
  onChange,
}: TextInputFieldProps) {
  return (
    <div className="reaction-edit-content">
      <label htmlFor={name}>{label}</label>
      <input
        type="text"
        name={name}
        placeholder={placeholder}
        value={value}
        onChange={onChange}
      />
      <hr />
    </div>
  );
}
