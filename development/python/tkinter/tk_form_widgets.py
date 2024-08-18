"""This is still a work-in-progress.

The form fields here are assumed to have a label and the UI should show label and the form field side-by-side.
"""

import tkinter as tk
from tkinter import ttk


# Label for the Form field
class FormLabel(ttk.Label):
    def __init__(self, parent, name):
        super().__init__(parent, text=name, width=10)
        self.grid(row=0, column=0, sticky="ew", padx=15)
        self.configure(anchor="e")


# Base class for Form fields
class FormItem(ttk.Frame):
    def __init__(self, parent, name):
        super().__init__(parent)
        self.grid(row=0, column=0, sticky="nsew", padx=50, pady=5)
        self.columnconfigure(1, weight=1)

        # Label
        self.label = FormLabel(self, name)


# Text Field
class FormTextField(FormItem):
    def __init__(self, parent, name):
        super().__init__(parent, name)

        # Text Field
        self.input_field = ttk.Entry(self)
        self.input_field.grid(row=0, column=1, sticky="ew", padx=15)


# Dropdown Menu (Non-Editable)
class FormOptionMenu(FormItem):
    def __init__(self, parent, name, options, defaultIndex):
        super().__init__(parent, name)

        # Default selection
        self.selected = tk.StringVar(value=options[defaultIndex])

        # Non-Editable Dropdown Menu
        self.option_menu = ttk.OptionMenu(self, self.selected, *options)
        self.option_menu.grid(row=0, column=1, sticky="ew", padx=15)


# Checkbox
class FormCheckButton(FormItem):
    def __init__(self, parent, name, button_text):
        super().__init__(parent, name)

        # Checked state
        self.checked = tk.IntVar(value=1)

        # Checkbox
        self.check_button = ttk.Checkbutton(self, text=button_text, var=self.checked)
        self.check_button.grid(row=0, column=1, sticky="ew", padx=15)


# Text Field (Integer) with increment and decrement arrows
class FormIntSpinBox(FormItem):
    def __init__(self, parent, name, start, end, defaultValue):
        super().__init__(parent, name)

        # Text Field with increment and decrement arrows
        self.spin_box = ttk.Spinbox(self, from_=start, to=end)
        self.spin_box.grid(row=0, column=1, sticky="ew", padx=15)
        self.spin_box.set(defaultValue)


# Dropdown Menu (Editable: user can type a value directly)
class FormComboBox(FormItem):
    def __init__(self, parent, name, options, defaultIndex):
        super().__init__(parent, name)

        # Default selection
        self.selected = tk.StringVar(value=options[defaultIndex])

        # Editable Dropdown Menu
        self.combo_box = ttk.Combobox(self, values=options, textvariable=self.selected)
        self.combo_box.grid(row=0, column=1, sticky="ew", padx=15)


# Multi-select list box
class FormMultiListBox(FormItem):
    def __init__(self, parent, name, options):
        super().__init__(parent, name)

        # List box
        self.list_box = tk.Listbox(self, selectmode=tk.MULTIPLE, height=10)
        self.list_box.grid(row=0, column=1, sticky="nsew", padx=15)

        # Scrollbar for the listbox
        self.scrollbar = ttk.Scrollbar(self, orient="vertical", command=self.list_box.yview)
        self.scrollbar.grid(row=0, column=1, sticky="nse")
        
        self.list_box.config(yscrollcommand=self.scrollbar.set)

        # Insert tags into the listbox
        for option in options:
            self.list_box.insert(tk.END, option)
