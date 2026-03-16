# Remove Leading Spaces in Notepad++

This method removes **blank spaces before text (leading spaces)** from every line in a file.

It works directly inside **Notepad++** and overwrites the same file.

---

## Steps

### Step 1

Press:

```
Ctrl + H
```

This opens the **Find and Replace** window.

---

### Step 2

Set **Search Mode** to:

```
Regular expression
```

---

### Step 3

**Find what**

```
^\h+
```

**Replace with**

```

```

(Leave the replace field **empty**)

---

### Step 4

Click:

```
Replace All
```

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
