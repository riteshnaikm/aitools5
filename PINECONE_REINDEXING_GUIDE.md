# Pinecone Re-indexing Guide

## 🗑️ **Manual Deletion**

### **Option 1: Pinecone Console (Easiest)**
1. Go to [Pinecone Console](https://app.pinecone.io)
2. Navigate to your index: `hr-knowledge-base-mk6xvmj`
3. Click on the index
4. Click **"Delete Index"** button
5. Confirm deletion

### **Option 2: Python Script**
```python
from pinecone import Pinecone
import os

pc = Pinecone(api_key=os.getenv('PINECONE_API_KEY'))
pc.delete_index("hr-knowledge-base-mk6xvmj")
print("✅ Index deleted successfully")
```

### **Option 3: Using Update Endpoint**
```bash
curl -X POST http://localhost:5000/api/update_index
```

---

## 📊 **Dimension Choice: 384 vs Higher**

### **Current Setup**
- **Your Code**: Uses `sentence-transformers/all-MiniLM-L6-v2` (384 dimensions)
- **Your Pinecone Index**: Shows `llama-text-embed-v2` (384 dimensions) - This might be metadata only
- **Record Count**: 374 chunks

### **Option A: Keep 384 Dimensions** ✅ **RECOMMENDED FOR NOW**

**Why?**
- ✅ No code changes needed
- ✅ Matches your current embedding model
- ✅ Faster indexing and search
- ✅ Lower storage costs
- ✅ Easier migration

**What to do:**
1. Delete existing index
2. Recreate with **384 dimensions** (same as before)
3. Restart app - it will auto-reindex with new chunking (1200 chars, 250 overlap)

**Impact:**
- ✅ Better chunking (larger chunks = better context)
- ✅ Better source citations (actual filenames)
- ✅ Same embedding quality (no change)
- ✅ Same search speed
- ⚠️ Fewer total chunks (~3x fewer, but larger chunks)

---

### **Option B: Upgrade to 768 Dimensions** ⭐ **BETTER QUALITY**

**Why?**
- ✅ Better semantic understanding
- ✅ Better retrieval accuracy
- ✅ Better handling of HR terminology
- ⚠️ Requires code changes
- ⚠️ Slower indexing/search (but still fast)
- ⚠️ Higher storage costs (but minimal)

**What to do:**
1. **Update embedding model in code**:
   ```python
   # In app.py, line ~377
   embeddings = HuggingFaceEmbeddings(
       model_name="sentence-transformers/all-mpnet-base-v2"  # 768 dim
   )
   ```

2. **Update Pinecone index creation**:
   ```python
   # In app.py, line ~2449
   pc.create_index(
       name=index_name,
       dimension=768,  # Changed from 384
       metric="cosine",
       spec=ServerlessSpec(cloud="aws", region="us-east-1")
   )
   ```

3. Delete existing index
4. Recreate with **768 dimensions**
5. Restart app

**Impact:**
- ✅ **+20-30%** better retrieval accuracy
- ✅ Better understanding of HR terminology
- ✅ Better semantic matching
- ⚠️ ~2x slower indexing (but still fast: ~5-10 seconds for 17 PDFs)
- ⚠️ ~2x larger storage (but still minimal: ~300KB vs 150KB)

---

### **Option C: Upgrade to 1024 Dimensions** ⭐⭐ **BEST QUALITY**

**Why?**
- ✅ Excellent semantic understanding
- ✅ Top-tier retrieval accuracy
- ✅ Best for domain-specific HR terminology
- ⚠️ Requires code changes
- ⚠️ Slowest indexing/search (but acceptable)
- ⚠️ Highest storage costs (but still minimal)

**What to do:**
1. **Update embedding model in code**:
   ```python
   # In app.py, line ~377
   embeddings = HuggingFaceEmbeddings(
       model_name="BAAI/bge-large-en-v1.5"  # 1024 dim
   )
   ```

2. **Update Pinecone index creation**:
   ```python
   # In app.py, line ~2449
   pc.create_index(
       name=index_name,
       dimension=1024,  # Changed from 384
       metric="cosine",
       spec=ServerlessSpec(cloud="aws", region="us-east-1")
   )
   ```

3. Delete existing index
4. Recreate with **1024 dimensions**
5. Restart app

**Impact:**
- ✅ **+30-40%** better retrieval accuracy
- ✅ Excellent understanding of HR terminology
- ✅ Best semantic matching
- ⚠️ ~3x slower indexing (but still acceptable: ~10-15 seconds)
- ⚠️ ~2.7x larger storage (but still minimal: ~400KB vs 150KB)

---

## 📊 **Dimension Impact Comparison**

| Dimension | Model | Quality | Speed | Storage | Recommendation |
|-----------|-------|---------|-------|---------|----------------|
| **384** | all-MiniLM-L6-v2 | Good | ⚡⚡⚡ Fast | 💾 Small | ✅ **Start here** |
| **768** | all-mpnet-base-v2 | Better | ⚡⚡ Medium | 💾💾 Medium | ⭐ Upgrade path |
| **1024** | bge-large-en-v1.5 | Best | ⚡ Slowest | 💾💾💾 Largest | ⭐⭐ Best quality |

---

## 🎯 **My Recommendation**

### **For Now: Keep 384 Dimensions** ✅

**Reasons:**
1. **Easier migration** - No code changes needed
2. **Faster setup** - Re-index immediately
3. **Good enough** - Current improvements (chunking + citations) will give significant boost
4. **Test first** - See how much better answers are with new chunking
5. **Upgrade later** - Can always upgrade to 768/1024 later if needed

### **When to Upgrade to 768/1024:**
- If you're still not getting good answers after re-indexing
- If you need better semantic understanding
- If you have time to test and optimize
- If storage/speed is not a concern

---

## 📝 **Step-by-Step: Re-index with 384 (Recommended)**

1. **Delete index in Pinecone console** (or use Python script above)

2. **Restart your Flask app**:
   ```bash
   # Stop current app
   # Start again
   python run.py
   ```

3. **App will automatically**:
   - Detect missing index
   - Create new index with 384 dimensions
   - Populate with new chunking (1200 chars, 250 overlap)
   - Build BM25 index with metadata

4. **Monitor logs** for:
   ```
   ✅ Index created successfully
   📚 Processing 17 PDF files
   ✅ Inserted batch X/Y
   🎉 Successfully populated index
   ✅ BM25 index built with metadata tracking
   ```

5. **Test with queries**:
   - "Leave policy" - Should cite actual filenames
   - "Performance appraisal" - Should show complete explanations
   - Check that citations show "Leave Policy.pdf" not "Source 1"

---

## ⚠️ **Important Notes**

1. **Dimension MUST match embedding model**:
   - `all-MiniLM-L6-v2` → 384 dim
   - `all-mpnet-base-v2` → 768 dim
   - `bge-large-en-v1.5` → 1024 dim

2. **Cannot change dimension on existing index**:
   - Must delete and recreate
   - All data will be lost (but you'll re-index anyway)

3. **Storage costs**:
   - 384 dim: ~0.4KB per vector
   - 768 dim: ~0.8KB per vector
   - 1024 dim: ~1KB per vector
   - For 374 records: Still minimal (150KB - 400KB)

4. **Search speed**:
   - 384 dim: Fastest (~50-100ms)
   - 768 dim: Medium (~100-200ms)
   - 1024 dim: Slowest (~150-300ms)
   - All are acceptable for real-time use

---

## 🚀 **Quick Start (384 Dimensions - Recommended)**

1. Delete index in Pinecone console
2. Restart app (auto-recreates and re-indexes)
3. Test queries
4. Done! ✅

**No code changes needed!**

---

**Last Updated**: After RAG upgrade implementation
**Status**: Ready for re-indexing

