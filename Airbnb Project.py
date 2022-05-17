#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd 
import numpy as np 


# In[16]:


path = "C:\\Users\\raymo\\Desktop\\Airbnb dataset\\AnbCalendardata\\calendar.csv"
dfc = pd.read_csv(path) 


# In[17]:


# check total row count
dfc.shape


# In[18]:


df = pd.read_csv(path)


# In[54]:


# Assign first 500k rows into an object
df = pd.read_csv(path, chunksize = 500000)


# In[55]:


# Iterate calendar file by 500k rows and output into smaller excel files
for i, f in enumerate(df): 
    f.to_excel(rf'C:\\Users\\raymo\\Desktop\\Airbnb dataset\\AnbCalendardata\\excel_calendarp{i}.xlsx')


# In[56]:


df = pd.read_csv(r'C:\\Users\\raymo\\Desktop\\Airbnb dataset\\AnbCalendardata\\listings.csv', chunksize = 500000)


# In[57]:


# Iterate listing file by 500k rows and output into smaller excel files
for i, f in enumerate(df): 
    f.to_excel(rf'C:\\Users\\raymo\\Desktop\\Airbnb dataset\\AnbCalendardata\\excel_listingsp{i}.xlsx')


# In[59]:


df = pd.read_csv(r'C:\\Users\\raymo\\Desktop\\Airbnb dataset\\AnbCalendardata\\neighbourhoods.csv', chunksize = 500000)


# In[60]:


for i, f in enumerate(df): 
    f.to_excel(rf'C:\\Users\\raymo\\Desktop\\Airbnb dataset\\AnbCalendardata\\excel_neighbourhoodsp{i}.xlsx')


# In[61]:


df = pd.read_csv(r'C:\\Users\\raymo\\Desktop\\Airbnb dataset\\AnbCalendardata\\reviews.csv', chunksize = 500000)


# In[62]:


for i, f in enumerate(df): 
    f.to_excel(rf'C:\\Users\\raymo\\Desktop\\Airbnb dataset\\AnbCalendardata\\excel_reviewsp{i}.xlsx')


# In[ ]:




