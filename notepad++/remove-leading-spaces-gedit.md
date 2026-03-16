# Remove Leading Spaces in Gedit

This method removes **blank spaces before text (leading spaces)** from every line in a file using **Gedit External Tools**.

It works directly inside **Gedit** and overwrites the same file.

---

## Steps

### Step 1

Open **External Tools Manager**

```
Tools → Manage External Tools
```

Click **+ (Add Tool)**.

---

### Step 2

Fill the tool settings as follows.

**Name**

```
RemoveLeadingSpaces
```

**Command**

```
sed -i 's/^[ \t]*//' "$GEDIT_CURRENT_DOCUMENT_PATH"
```

**Input**

```
Nothing
```

**Output**

```
Nothing
```

Save the tool.

---

### Step 3

Open the file you want to clean in **Gedit**.

Run the tool:

```
Tools → External Tools → RemoveLeadingSpaces
```

The file will be updated immediately.

---

## Example

### Before

```
        input clk;
    input rst;
            output sum;
```

### After

```
input clk;
input rst;
output sum;
```

---

## Why This Is the Best Solution

- Works directly inside **Gedit**
- No Python script required
- File is updated **in place**
- Works for **Verilog, TCL, STA reports, and text files**
- Fast even for large files
