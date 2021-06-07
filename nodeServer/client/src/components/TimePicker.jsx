import React from 'react';
import DatePicker from "react-datepicker";
import "react-datepicker/dist/react-datepicker.css";

function TimePicker({ startDate, setStartDate }) {

  return (
    <DatePicker
      selected={startDate}
      onChange={(date) => setStartDate(date)}
      timeInputLabel="Time:"
      dateFormat="MM/dd/yyyy h:mm:ss aa"
      minDate={new Date()}
      showTimeInput
      showYearDropdown
      scrollableYearDropdown
    />
  );
};

export default TimePicker
