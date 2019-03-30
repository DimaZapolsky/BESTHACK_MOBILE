import os

os.chdir('Backend')
os.chdir('banks')
output = open('jsons', 'w')
for s in os.listdir():
    with open(s, 'r') as f:
        st = f.readlines()
        print(st)
        ans = '\"'
        for c in ''.join(st):
            if c == '\"':
                ans = ans + '\\\"'
            elif c == '\n':
                ans = ans + '\\n'
            else:
                ans = ans + c
        ans = ans + '\"'
        output.write('banks.push_back(json::parse(' + ans + '));' + '\n')
