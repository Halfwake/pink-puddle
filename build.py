import glob
import os
import zipfile

FILE_NAME = 'test.love'

try:
    os.remove(FILE_NAME)
except:
    pass
git_ignore_f = open('.gitignore')
git_ignore = git_ignore_f.readlines()
git_ignore_f.close()

to_ignore = []
for ignore in git_ignore:
    to_ignore.extend(glob.glob(ignore))

all_names = [name for name in os.listdir(os.getcwd()) if os.path.isfile(name)]
to_archive = []
for name in all_names:
    if name not in to_ignore:
        to_archive.append(name)

archive = zipfile.ZipFile(FILE_NAME, mode='w')
for name in to_archive:
    print 'Writing'
    archive.write(name)
archive.close()
print 'Finished'

