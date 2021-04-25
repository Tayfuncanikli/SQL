#!/usr/bin/env python
# coding: utf-8

# In[2]:


age = str(input('Are you a cigarette addict older than 75 years old?(yes/no):'))
chronic = str(input('Do you have a severe chronic disease?yes/no:'))
immune = str(input('Is your immune system too weak?yes/no:'))
if age=="yes" or chronic=="yes" or immune=="yes":
    print("You are in risky group")
else :
    print("You are not in risky group")


# In[ ]:




