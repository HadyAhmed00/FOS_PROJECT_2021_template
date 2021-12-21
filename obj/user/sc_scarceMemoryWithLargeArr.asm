
obj/user/sc_scarceMemoryWithLargeArr:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	mov $0, %eax
  800020:	b8 00 00 00 00       	mov    $0x0,%eax
	cmpl $USTACKTOP, %esp
  800025:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  80002b:	75 04                	jne    800031 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  80002d:	6a 00                	push   $0x0
	pushl $0
  80002f:	6a 00                	push   $0x0

00800031 <args_exist>:

args_exist:
	call libmain
  800031:	e8 70 00 00 00       	call   8000a6 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

//char Elements[102400*PAGE_SIZE];
char Elements[25600*PAGE_SIZE];
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	/*[1] CREATE LARGE ARRAY THAT SCARCE MEMORY*/
	env_sleep(500000);
  80003e:	83 ec 0c             	sub    $0xc,%esp
  800041:	68 20 a1 07 00       	push   $0x7a120
  800046:	e8 d5 19 00 00       	call   801a20 <env_sleep>
  80004b:	83 c4 10             	add    $0x10,%esp
	uint32 required_size = sizeof(int) * 3;
  80004e:	c7 45 f0 0c 00 00 00 	movl   $0xc,-0x10(%ebp)
	uint32 *Elements2 = malloc(required_size) ;
  800055:	83 ec 0c             	sub    $0xc,%esp
  800058:	ff 75 f0             	pushl  -0x10(%ebp)
  80005b:	e8 e9 0f 00 00       	call   801049 <malloc>
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	89 45 ec             	mov    %eax,-0x14(%ebp)
//
//	for(uint32 i = 0; i < 13500*PAGE_SIZE; i+=PAGE_SIZE)
//	{
//		Elements[i] = 0;
//	}
	for(uint32 i = 0; i < required_size; i+=PAGE_SIZE)
  800066:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80006d:	eb 1c                	jmp    80008b <_main+0x53>
	{
		Elements2[i] = 0;
  80006f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800072:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800079:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80007c:	01 d0                	add    %edx,%eax
  80007e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
//
//	for(uint32 i = 0; i < 13500*PAGE_SIZE; i+=PAGE_SIZE)
//	{
//		Elements[i] = 0;
//	}
	for(uint32 i = 0; i < required_size; i+=PAGE_SIZE)
  800084:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  80008b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80008e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800091:	72 dc                	jb     80006f <_main+0x37>
	{
		Elements2[i] = 0;
	}

	cprintf("Congratulations!! Scenario of Handling SCARCE MEM is completed successfully!!\n\n\n");
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	68 20 1f 80 00       	push   $0x801f20
  80009b:	e8 1f 02 00 00       	call   8002bf <cprintf>
  8000a0:	83 c4 10             	add    $0x10,%esp

	return;
  8000a3:	90                   	nop
}
  8000a4:	c9                   	leave  
  8000a5:	c3                   	ret    

008000a6 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000a6:	55                   	push   %ebp
  8000a7:	89 e5                	mov    %esp,%ebp
  8000a9:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000ac:	e8 b3 13 00 00       	call   801464 <sys_getenvindex>
  8000b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000b7:	89 d0                	mov    %edx,%eax
  8000b9:	c1 e0 03             	shl    $0x3,%eax
  8000bc:	01 d0                	add    %edx,%eax
  8000be:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8000c5:	01 c8                	add    %ecx,%eax
  8000c7:	01 c0                	add    %eax,%eax
  8000c9:	01 d0                	add    %edx,%eax
  8000cb:	01 c0                	add    %eax,%eax
  8000cd:	01 d0                	add    %edx,%eax
  8000cf:	89 c2                	mov    %eax,%edx
  8000d1:	c1 e2 05             	shl    $0x5,%edx
  8000d4:	29 c2                	sub    %eax,%edx
  8000d6:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8000dd:	89 c2                	mov    %eax,%edx
  8000df:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8000e5:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000ea:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ef:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8000f5:	84 c0                	test   %al,%al
  8000f7:	74 0f                	je     800108 <libmain+0x62>
		binaryname = myEnv->prog_name;
  8000f9:	a1 20 30 80 00       	mov    0x803020,%eax
  8000fe:	05 40 3c 01 00       	add    $0x13c40,%eax
  800103:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800108:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80010c:	7e 0a                	jle    800118 <libmain+0x72>
		binaryname = argv[0];
  80010e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800111:	8b 00                	mov    (%eax),%eax
  800113:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800118:	83 ec 08             	sub    $0x8,%esp
  80011b:	ff 75 0c             	pushl  0xc(%ebp)
  80011e:	ff 75 08             	pushl  0x8(%ebp)
  800121:	e8 12 ff ff ff       	call   800038 <_main>
  800126:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800129:	e8 d1 14 00 00       	call   8015ff <sys_disable_interrupt>
	cprintf("**************************************\n");
  80012e:	83 ec 0c             	sub    $0xc,%esp
  800131:	68 8c 1f 80 00       	push   $0x801f8c
  800136:	e8 84 01 00 00       	call   8002bf <cprintf>
  80013b:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80013e:	a1 20 30 80 00       	mov    0x803020,%eax
  800143:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800149:	a1 20 30 80 00       	mov    0x803020,%eax
  80014e:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800154:	83 ec 04             	sub    $0x4,%esp
  800157:	52                   	push   %edx
  800158:	50                   	push   %eax
  800159:	68 b4 1f 80 00       	push   $0x801fb4
  80015e:	e8 5c 01 00 00       	call   8002bf <cprintf>
  800163:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800166:	a1 20 30 80 00       	mov    0x803020,%eax
  80016b:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800171:	a1 20 30 80 00       	mov    0x803020,%eax
  800176:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  80017c:	83 ec 04             	sub    $0x4,%esp
  80017f:	52                   	push   %edx
  800180:	50                   	push   %eax
  800181:	68 dc 1f 80 00       	push   $0x801fdc
  800186:	e8 34 01 00 00       	call   8002bf <cprintf>
  80018b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80018e:	a1 20 30 80 00       	mov    0x803020,%eax
  800193:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800199:	83 ec 08             	sub    $0x8,%esp
  80019c:	50                   	push   %eax
  80019d:	68 1d 20 80 00       	push   $0x80201d
  8001a2:	e8 18 01 00 00       	call   8002bf <cprintf>
  8001a7:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8001aa:	83 ec 0c             	sub    $0xc,%esp
  8001ad:	68 8c 1f 80 00       	push   $0x801f8c
  8001b2:	e8 08 01 00 00       	call   8002bf <cprintf>
  8001b7:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001ba:	e8 5a 14 00 00       	call   801619 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8001bf:	e8 19 00 00 00       	call   8001dd <exit>
}
  8001c4:	90                   	nop
  8001c5:	c9                   	leave  
  8001c6:	c3                   	ret    

008001c7 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001c7:	55                   	push   %ebp
  8001c8:	89 e5                	mov    %esp,%ebp
  8001ca:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8001cd:	83 ec 0c             	sub    $0xc,%esp
  8001d0:	6a 00                	push   $0x0
  8001d2:	e8 59 12 00 00       	call   801430 <sys_env_destroy>
  8001d7:	83 c4 10             	add    $0x10,%esp
}
  8001da:	90                   	nop
  8001db:	c9                   	leave  
  8001dc:	c3                   	ret    

008001dd <exit>:

void
exit(void)
{
  8001dd:	55                   	push   %ebp
  8001de:	89 e5                	mov    %esp,%ebp
  8001e0:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8001e3:	e8 ae 12 00 00       	call   801496 <sys_env_exit>
}
  8001e8:	90                   	nop
  8001e9:	c9                   	leave  
  8001ea:	c3                   	ret    

008001eb <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8001eb:	55                   	push   %ebp
  8001ec:	89 e5                	mov    %esp,%ebp
  8001ee:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8001f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f4:	8b 00                	mov    (%eax),%eax
  8001f6:	8d 48 01             	lea    0x1(%eax),%ecx
  8001f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001fc:	89 0a                	mov    %ecx,(%edx)
  8001fe:	8b 55 08             	mov    0x8(%ebp),%edx
  800201:	88 d1                	mov    %dl,%cl
  800203:	8b 55 0c             	mov    0xc(%ebp),%edx
  800206:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80020a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020d:	8b 00                	mov    (%eax),%eax
  80020f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800214:	75 2c                	jne    800242 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800216:	a0 24 30 80 00       	mov    0x803024,%al
  80021b:	0f b6 c0             	movzbl %al,%eax
  80021e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800221:	8b 12                	mov    (%edx),%edx
  800223:	89 d1                	mov    %edx,%ecx
  800225:	8b 55 0c             	mov    0xc(%ebp),%edx
  800228:	83 c2 08             	add    $0x8,%edx
  80022b:	83 ec 04             	sub    $0x4,%esp
  80022e:	50                   	push   %eax
  80022f:	51                   	push   %ecx
  800230:	52                   	push   %edx
  800231:	e8 b8 11 00 00       	call   8013ee <sys_cputs>
  800236:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800239:	8b 45 0c             	mov    0xc(%ebp),%eax
  80023c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800242:	8b 45 0c             	mov    0xc(%ebp),%eax
  800245:	8b 40 04             	mov    0x4(%eax),%eax
  800248:	8d 50 01             	lea    0x1(%eax),%edx
  80024b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80024e:	89 50 04             	mov    %edx,0x4(%eax)
}
  800251:	90                   	nop
  800252:	c9                   	leave  
  800253:	c3                   	ret    

00800254 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800254:	55                   	push   %ebp
  800255:	89 e5                	mov    %esp,%ebp
  800257:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80025d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800264:	00 00 00 
	b.cnt = 0;
  800267:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80026e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800271:	ff 75 0c             	pushl  0xc(%ebp)
  800274:	ff 75 08             	pushl  0x8(%ebp)
  800277:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80027d:	50                   	push   %eax
  80027e:	68 eb 01 80 00       	push   $0x8001eb
  800283:	e8 11 02 00 00       	call   800499 <vprintfmt>
  800288:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80028b:	a0 24 30 80 00       	mov    0x803024,%al
  800290:	0f b6 c0             	movzbl %al,%eax
  800293:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800299:	83 ec 04             	sub    $0x4,%esp
  80029c:	50                   	push   %eax
  80029d:	52                   	push   %edx
  80029e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002a4:	83 c0 08             	add    $0x8,%eax
  8002a7:	50                   	push   %eax
  8002a8:	e8 41 11 00 00       	call   8013ee <sys_cputs>
  8002ad:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002b0:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8002b7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002bd:	c9                   	leave  
  8002be:	c3                   	ret    

008002bf <cprintf>:

int cprintf(const char *fmt, ...) {
  8002bf:	55                   	push   %ebp
  8002c0:	89 e5                	mov    %esp,%ebp
  8002c2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002c5:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8002cc:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d5:	83 ec 08             	sub    $0x8,%esp
  8002d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8002db:	50                   	push   %eax
  8002dc:	e8 73 ff ff ff       	call   800254 <vcprintf>
  8002e1:	83 c4 10             	add    $0x10,%esp
  8002e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8002e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002ea:	c9                   	leave  
  8002eb:	c3                   	ret    

008002ec <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8002ec:	55                   	push   %ebp
  8002ed:	89 e5                	mov    %esp,%ebp
  8002ef:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8002f2:	e8 08 13 00 00       	call   8015ff <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002f7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800300:	83 ec 08             	sub    $0x8,%esp
  800303:	ff 75 f4             	pushl  -0xc(%ebp)
  800306:	50                   	push   %eax
  800307:	e8 48 ff ff ff       	call   800254 <vcprintf>
  80030c:	83 c4 10             	add    $0x10,%esp
  80030f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800312:	e8 02 13 00 00       	call   801619 <sys_enable_interrupt>
	return cnt;
  800317:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80031a:	c9                   	leave  
  80031b:	c3                   	ret    

0080031c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80031c:	55                   	push   %ebp
  80031d:	89 e5                	mov    %esp,%ebp
  80031f:	53                   	push   %ebx
  800320:	83 ec 14             	sub    $0x14,%esp
  800323:	8b 45 10             	mov    0x10(%ebp),%eax
  800326:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800329:	8b 45 14             	mov    0x14(%ebp),%eax
  80032c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80032f:	8b 45 18             	mov    0x18(%ebp),%eax
  800332:	ba 00 00 00 00       	mov    $0x0,%edx
  800337:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80033a:	77 55                	ja     800391 <printnum+0x75>
  80033c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80033f:	72 05                	jb     800346 <printnum+0x2a>
  800341:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800344:	77 4b                	ja     800391 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800346:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800349:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80034c:	8b 45 18             	mov    0x18(%ebp),%eax
  80034f:	ba 00 00 00 00       	mov    $0x0,%edx
  800354:	52                   	push   %edx
  800355:	50                   	push   %eax
  800356:	ff 75 f4             	pushl  -0xc(%ebp)
  800359:	ff 75 f0             	pushl  -0x10(%ebp)
  80035c:	e8 43 19 00 00       	call   801ca4 <__udivdi3>
  800361:	83 c4 10             	add    $0x10,%esp
  800364:	83 ec 04             	sub    $0x4,%esp
  800367:	ff 75 20             	pushl  0x20(%ebp)
  80036a:	53                   	push   %ebx
  80036b:	ff 75 18             	pushl  0x18(%ebp)
  80036e:	52                   	push   %edx
  80036f:	50                   	push   %eax
  800370:	ff 75 0c             	pushl  0xc(%ebp)
  800373:	ff 75 08             	pushl  0x8(%ebp)
  800376:	e8 a1 ff ff ff       	call   80031c <printnum>
  80037b:	83 c4 20             	add    $0x20,%esp
  80037e:	eb 1a                	jmp    80039a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800380:	83 ec 08             	sub    $0x8,%esp
  800383:	ff 75 0c             	pushl  0xc(%ebp)
  800386:	ff 75 20             	pushl  0x20(%ebp)
  800389:	8b 45 08             	mov    0x8(%ebp),%eax
  80038c:	ff d0                	call   *%eax
  80038e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800391:	ff 4d 1c             	decl   0x1c(%ebp)
  800394:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800398:	7f e6                	jg     800380 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80039a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80039d:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003a8:	53                   	push   %ebx
  8003a9:	51                   	push   %ecx
  8003aa:	52                   	push   %edx
  8003ab:	50                   	push   %eax
  8003ac:	e8 03 1a 00 00       	call   801db4 <__umoddi3>
  8003b1:	83 c4 10             	add    $0x10,%esp
  8003b4:	05 54 22 80 00       	add    $0x802254,%eax
  8003b9:	8a 00                	mov    (%eax),%al
  8003bb:	0f be c0             	movsbl %al,%eax
  8003be:	83 ec 08             	sub    $0x8,%esp
  8003c1:	ff 75 0c             	pushl  0xc(%ebp)
  8003c4:	50                   	push   %eax
  8003c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c8:	ff d0                	call   *%eax
  8003ca:	83 c4 10             	add    $0x10,%esp
}
  8003cd:	90                   	nop
  8003ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003d1:	c9                   	leave  
  8003d2:	c3                   	ret    

008003d3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003d3:	55                   	push   %ebp
  8003d4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003d6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003da:	7e 1c                	jle    8003f8 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8003dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003df:	8b 00                	mov    (%eax),%eax
  8003e1:	8d 50 08             	lea    0x8(%eax),%edx
  8003e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e7:	89 10                	mov    %edx,(%eax)
  8003e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ec:	8b 00                	mov    (%eax),%eax
  8003ee:	83 e8 08             	sub    $0x8,%eax
  8003f1:	8b 50 04             	mov    0x4(%eax),%edx
  8003f4:	8b 00                	mov    (%eax),%eax
  8003f6:	eb 40                	jmp    800438 <getuint+0x65>
	else if (lflag)
  8003f8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003fc:	74 1e                	je     80041c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8003fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800401:	8b 00                	mov    (%eax),%eax
  800403:	8d 50 04             	lea    0x4(%eax),%edx
  800406:	8b 45 08             	mov    0x8(%ebp),%eax
  800409:	89 10                	mov    %edx,(%eax)
  80040b:	8b 45 08             	mov    0x8(%ebp),%eax
  80040e:	8b 00                	mov    (%eax),%eax
  800410:	83 e8 04             	sub    $0x4,%eax
  800413:	8b 00                	mov    (%eax),%eax
  800415:	ba 00 00 00 00       	mov    $0x0,%edx
  80041a:	eb 1c                	jmp    800438 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80041c:	8b 45 08             	mov    0x8(%ebp),%eax
  80041f:	8b 00                	mov    (%eax),%eax
  800421:	8d 50 04             	lea    0x4(%eax),%edx
  800424:	8b 45 08             	mov    0x8(%ebp),%eax
  800427:	89 10                	mov    %edx,(%eax)
  800429:	8b 45 08             	mov    0x8(%ebp),%eax
  80042c:	8b 00                	mov    (%eax),%eax
  80042e:	83 e8 04             	sub    $0x4,%eax
  800431:	8b 00                	mov    (%eax),%eax
  800433:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800438:	5d                   	pop    %ebp
  800439:	c3                   	ret    

0080043a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80043a:	55                   	push   %ebp
  80043b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80043d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800441:	7e 1c                	jle    80045f <getint+0x25>
		return va_arg(*ap, long long);
  800443:	8b 45 08             	mov    0x8(%ebp),%eax
  800446:	8b 00                	mov    (%eax),%eax
  800448:	8d 50 08             	lea    0x8(%eax),%edx
  80044b:	8b 45 08             	mov    0x8(%ebp),%eax
  80044e:	89 10                	mov    %edx,(%eax)
  800450:	8b 45 08             	mov    0x8(%ebp),%eax
  800453:	8b 00                	mov    (%eax),%eax
  800455:	83 e8 08             	sub    $0x8,%eax
  800458:	8b 50 04             	mov    0x4(%eax),%edx
  80045b:	8b 00                	mov    (%eax),%eax
  80045d:	eb 38                	jmp    800497 <getint+0x5d>
	else if (lflag)
  80045f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800463:	74 1a                	je     80047f <getint+0x45>
		return va_arg(*ap, long);
  800465:	8b 45 08             	mov    0x8(%ebp),%eax
  800468:	8b 00                	mov    (%eax),%eax
  80046a:	8d 50 04             	lea    0x4(%eax),%edx
  80046d:	8b 45 08             	mov    0x8(%ebp),%eax
  800470:	89 10                	mov    %edx,(%eax)
  800472:	8b 45 08             	mov    0x8(%ebp),%eax
  800475:	8b 00                	mov    (%eax),%eax
  800477:	83 e8 04             	sub    $0x4,%eax
  80047a:	8b 00                	mov    (%eax),%eax
  80047c:	99                   	cltd   
  80047d:	eb 18                	jmp    800497 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80047f:	8b 45 08             	mov    0x8(%ebp),%eax
  800482:	8b 00                	mov    (%eax),%eax
  800484:	8d 50 04             	lea    0x4(%eax),%edx
  800487:	8b 45 08             	mov    0x8(%ebp),%eax
  80048a:	89 10                	mov    %edx,(%eax)
  80048c:	8b 45 08             	mov    0x8(%ebp),%eax
  80048f:	8b 00                	mov    (%eax),%eax
  800491:	83 e8 04             	sub    $0x4,%eax
  800494:	8b 00                	mov    (%eax),%eax
  800496:	99                   	cltd   
}
  800497:	5d                   	pop    %ebp
  800498:	c3                   	ret    

00800499 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800499:	55                   	push   %ebp
  80049a:	89 e5                	mov    %esp,%ebp
  80049c:	56                   	push   %esi
  80049d:	53                   	push   %ebx
  80049e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004a1:	eb 17                	jmp    8004ba <vprintfmt+0x21>
			if (ch == '\0')
  8004a3:	85 db                	test   %ebx,%ebx
  8004a5:	0f 84 af 03 00 00    	je     80085a <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8004ab:	83 ec 08             	sub    $0x8,%esp
  8004ae:	ff 75 0c             	pushl  0xc(%ebp)
  8004b1:	53                   	push   %ebx
  8004b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b5:	ff d0                	call   *%eax
  8004b7:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8004bd:	8d 50 01             	lea    0x1(%eax),%edx
  8004c0:	89 55 10             	mov    %edx,0x10(%ebp)
  8004c3:	8a 00                	mov    (%eax),%al
  8004c5:	0f b6 d8             	movzbl %al,%ebx
  8004c8:	83 fb 25             	cmp    $0x25,%ebx
  8004cb:	75 d6                	jne    8004a3 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004cd:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004d1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8004d8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004df:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8004e6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f0:	8d 50 01             	lea    0x1(%eax),%edx
  8004f3:	89 55 10             	mov    %edx,0x10(%ebp)
  8004f6:	8a 00                	mov    (%eax),%al
  8004f8:	0f b6 d8             	movzbl %al,%ebx
  8004fb:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8004fe:	83 f8 55             	cmp    $0x55,%eax
  800501:	0f 87 2b 03 00 00    	ja     800832 <vprintfmt+0x399>
  800507:	8b 04 85 78 22 80 00 	mov    0x802278(,%eax,4),%eax
  80050e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800510:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800514:	eb d7                	jmp    8004ed <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800516:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80051a:	eb d1                	jmp    8004ed <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80051c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800523:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800526:	89 d0                	mov    %edx,%eax
  800528:	c1 e0 02             	shl    $0x2,%eax
  80052b:	01 d0                	add    %edx,%eax
  80052d:	01 c0                	add    %eax,%eax
  80052f:	01 d8                	add    %ebx,%eax
  800531:	83 e8 30             	sub    $0x30,%eax
  800534:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800537:	8b 45 10             	mov    0x10(%ebp),%eax
  80053a:	8a 00                	mov    (%eax),%al
  80053c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80053f:	83 fb 2f             	cmp    $0x2f,%ebx
  800542:	7e 3e                	jle    800582 <vprintfmt+0xe9>
  800544:	83 fb 39             	cmp    $0x39,%ebx
  800547:	7f 39                	jg     800582 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800549:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80054c:	eb d5                	jmp    800523 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80054e:	8b 45 14             	mov    0x14(%ebp),%eax
  800551:	83 c0 04             	add    $0x4,%eax
  800554:	89 45 14             	mov    %eax,0x14(%ebp)
  800557:	8b 45 14             	mov    0x14(%ebp),%eax
  80055a:	83 e8 04             	sub    $0x4,%eax
  80055d:	8b 00                	mov    (%eax),%eax
  80055f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800562:	eb 1f                	jmp    800583 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800564:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800568:	79 83                	jns    8004ed <vprintfmt+0x54>
				width = 0;
  80056a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800571:	e9 77 ff ff ff       	jmp    8004ed <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800576:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80057d:	e9 6b ff ff ff       	jmp    8004ed <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800582:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800583:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800587:	0f 89 60 ff ff ff    	jns    8004ed <vprintfmt+0x54>
				width = precision, precision = -1;
  80058d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800590:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800593:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80059a:	e9 4e ff ff ff       	jmp    8004ed <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80059f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005a2:	e9 46 ff ff ff       	jmp    8004ed <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005aa:	83 c0 04             	add    $0x4,%eax
  8005ad:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b3:	83 e8 04             	sub    $0x4,%eax
  8005b6:	8b 00                	mov    (%eax),%eax
  8005b8:	83 ec 08             	sub    $0x8,%esp
  8005bb:	ff 75 0c             	pushl  0xc(%ebp)
  8005be:	50                   	push   %eax
  8005bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c2:	ff d0                	call   *%eax
  8005c4:	83 c4 10             	add    $0x10,%esp
			break;
  8005c7:	e9 89 02 00 00       	jmp    800855 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cf:	83 c0 04             	add    $0x4,%eax
  8005d2:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d8:	83 e8 04             	sub    $0x4,%eax
  8005db:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8005dd:	85 db                	test   %ebx,%ebx
  8005df:	79 02                	jns    8005e3 <vprintfmt+0x14a>
				err = -err;
  8005e1:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005e3:	83 fb 64             	cmp    $0x64,%ebx
  8005e6:	7f 0b                	jg     8005f3 <vprintfmt+0x15a>
  8005e8:	8b 34 9d c0 20 80 00 	mov    0x8020c0(,%ebx,4),%esi
  8005ef:	85 f6                	test   %esi,%esi
  8005f1:	75 19                	jne    80060c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8005f3:	53                   	push   %ebx
  8005f4:	68 65 22 80 00       	push   $0x802265
  8005f9:	ff 75 0c             	pushl  0xc(%ebp)
  8005fc:	ff 75 08             	pushl  0x8(%ebp)
  8005ff:	e8 5e 02 00 00       	call   800862 <printfmt>
  800604:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800607:	e9 49 02 00 00       	jmp    800855 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80060c:	56                   	push   %esi
  80060d:	68 6e 22 80 00       	push   $0x80226e
  800612:	ff 75 0c             	pushl  0xc(%ebp)
  800615:	ff 75 08             	pushl  0x8(%ebp)
  800618:	e8 45 02 00 00       	call   800862 <printfmt>
  80061d:	83 c4 10             	add    $0x10,%esp
			break;
  800620:	e9 30 02 00 00       	jmp    800855 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800625:	8b 45 14             	mov    0x14(%ebp),%eax
  800628:	83 c0 04             	add    $0x4,%eax
  80062b:	89 45 14             	mov    %eax,0x14(%ebp)
  80062e:	8b 45 14             	mov    0x14(%ebp),%eax
  800631:	83 e8 04             	sub    $0x4,%eax
  800634:	8b 30                	mov    (%eax),%esi
  800636:	85 f6                	test   %esi,%esi
  800638:	75 05                	jne    80063f <vprintfmt+0x1a6>
				p = "(null)";
  80063a:	be 71 22 80 00       	mov    $0x802271,%esi
			if (width > 0 && padc != '-')
  80063f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800643:	7e 6d                	jle    8006b2 <vprintfmt+0x219>
  800645:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800649:	74 67                	je     8006b2 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80064b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80064e:	83 ec 08             	sub    $0x8,%esp
  800651:	50                   	push   %eax
  800652:	56                   	push   %esi
  800653:	e8 0c 03 00 00       	call   800964 <strnlen>
  800658:	83 c4 10             	add    $0x10,%esp
  80065b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80065e:	eb 16                	jmp    800676 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800660:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800664:	83 ec 08             	sub    $0x8,%esp
  800667:	ff 75 0c             	pushl  0xc(%ebp)
  80066a:	50                   	push   %eax
  80066b:	8b 45 08             	mov    0x8(%ebp),%eax
  80066e:	ff d0                	call   *%eax
  800670:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800673:	ff 4d e4             	decl   -0x1c(%ebp)
  800676:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80067a:	7f e4                	jg     800660 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80067c:	eb 34                	jmp    8006b2 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80067e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800682:	74 1c                	je     8006a0 <vprintfmt+0x207>
  800684:	83 fb 1f             	cmp    $0x1f,%ebx
  800687:	7e 05                	jle    80068e <vprintfmt+0x1f5>
  800689:	83 fb 7e             	cmp    $0x7e,%ebx
  80068c:	7e 12                	jle    8006a0 <vprintfmt+0x207>
					putch('?', putdat);
  80068e:	83 ec 08             	sub    $0x8,%esp
  800691:	ff 75 0c             	pushl  0xc(%ebp)
  800694:	6a 3f                	push   $0x3f
  800696:	8b 45 08             	mov    0x8(%ebp),%eax
  800699:	ff d0                	call   *%eax
  80069b:	83 c4 10             	add    $0x10,%esp
  80069e:	eb 0f                	jmp    8006af <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006a0:	83 ec 08             	sub    $0x8,%esp
  8006a3:	ff 75 0c             	pushl  0xc(%ebp)
  8006a6:	53                   	push   %ebx
  8006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006aa:	ff d0                	call   *%eax
  8006ac:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006af:	ff 4d e4             	decl   -0x1c(%ebp)
  8006b2:	89 f0                	mov    %esi,%eax
  8006b4:	8d 70 01             	lea    0x1(%eax),%esi
  8006b7:	8a 00                	mov    (%eax),%al
  8006b9:	0f be d8             	movsbl %al,%ebx
  8006bc:	85 db                	test   %ebx,%ebx
  8006be:	74 24                	je     8006e4 <vprintfmt+0x24b>
  8006c0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006c4:	78 b8                	js     80067e <vprintfmt+0x1e5>
  8006c6:	ff 4d e0             	decl   -0x20(%ebp)
  8006c9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006cd:	79 af                	jns    80067e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006cf:	eb 13                	jmp    8006e4 <vprintfmt+0x24b>
				putch(' ', putdat);
  8006d1:	83 ec 08             	sub    $0x8,%esp
  8006d4:	ff 75 0c             	pushl  0xc(%ebp)
  8006d7:	6a 20                	push   $0x20
  8006d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dc:	ff d0                	call   *%eax
  8006de:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006e1:	ff 4d e4             	decl   -0x1c(%ebp)
  8006e4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006e8:	7f e7                	jg     8006d1 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8006ea:	e9 66 01 00 00       	jmp    800855 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006ef:	83 ec 08             	sub    $0x8,%esp
  8006f2:	ff 75 e8             	pushl  -0x18(%ebp)
  8006f5:	8d 45 14             	lea    0x14(%ebp),%eax
  8006f8:	50                   	push   %eax
  8006f9:	e8 3c fd ff ff       	call   80043a <getint>
  8006fe:	83 c4 10             	add    $0x10,%esp
  800701:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800704:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800707:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80070a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80070d:	85 d2                	test   %edx,%edx
  80070f:	79 23                	jns    800734 <vprintfmt+0x29b>
				putch('-', putdat);
  800711:	83 ec 08             	sub    $0x8,%esp
  800714:	ff 75 0c             	pushl  0xc(%ebp)
  800717:	6a 2d                	push   $0x2d
  800719:	8b 45 08             	mov    0x8(%ebp),%eax
  80071c:	ff d0                	call   *%eax
  80071e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800721:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800724:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800727:	f7 d8                	neg    %eax
  800729:	83 d2 00             	adc    $0x0,%edx
  80072c:	f7 da                	neg    %edx
  80072e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800731:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800734:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80073b:	e9 bc 00 00 00       	jmp    8007fc <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800740:	83 ec 08             	sub    $0x8,%esp
  800743:	ff 75 e8             	pushl  -0x18(%ebp)
  800746:	8d 45 14             	lea    0x14(%ebp),%eax
  800749:	50                   	push   %eax
  80074a:	e8 84 fc ff ff       	call   8003d3 <getuint>
  80074f:	83 c4 10             	add    $0x10,%esp
  800752:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800755:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800758:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80075f:	e9 98 00 00 00       	jmp    8007fc <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800764:	83 ec 08             	sub    $0x8,%esp
  800767:	ff 75 0c             	pushl  0xc(%ebp)
  80076a:	6a 58                	push   $0x58
  80076c:	8b 45 08             	mov    0x8(%ebp),%eax
  80076f:	ff d0                	call   *%eax
  800771:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800774:	83 ec 08             	sub    $0x8,%esp
  800777:	ff 75 0c             	pushl  0xc(%ebp)
  80077a:	6a 58                	push   $0x58
  80077c:	8b 45 08             	mov    0x8(%ebp),%eax
  80077f:	ff d0                	call   *%eax
  800781:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	ff 75 0c             	pushl  0xc(%ebp)
  80078a:	6a 58                	push   $0x58
  80078c:	8b 45 08             	mov    0x8(%ebp),%eax
  80078f:	ff d0                	call   *%eax
  800791:	83 c4 10             	add    $0x10,%esp
			break;
  800794:	e9 bc 00 00 00       	jmp    800855 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800799:	83 ec 08             	sub    $0x8,%esp
  80079c:	ff 75 0c             	pushl  0xc(%ebp)
  80079f:	6a 30                	push   $0x30
  8007a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a4:	ff d0                	call   *%eax
  8007a6:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007a9:	83 ec 08             	sub    $0x8,%esp
  8007ac:	ff 75 0c             	pushl  0xc(%ebp)
  8007af:	6a 78                	push   $0x78
  8007b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b4:	ff d0                	call   *%eax
  8007b6:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bc:	83 c0 04             	add    $0x4,%eax
  8007bf:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c5:	83 e8 04             	sub    $0x4,%eax
  8007c8:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8007d4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8007db:	eb 1f                	jmp    8007fc <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007dd:	83 ec 08             	sub    $0x8,%esp
  8007e0:	ff 75 e8             	pushl  -0x18(%ebp)
  8007e3:	8d 45 14             	lea    0x14(%ebp),%eax
  8007e6:	50                   	push   %eax
  8007e7:	e8 e7 fb ff ff       	call   8003d3 <getuint>
  8007ec:	83 c4 10             	add    $0x10,%esp
  8007ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8007f5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007fc:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800800:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800803:	83 ec 04             	sub    $0x4,%esp
  800806:	52                   	push   %edx
  800807:	ff 75 e4             	pushl  -0x1c(%ebp)
  80080a:	50                   	push   %eax
  80080b:	ff 75 f4             	pushl  -0xc(%ebp)
  80080e:	ff 75 f0             	pushl  -0x10(%ebp)
  800811:	ff 75 0c             	pushl  0xc(%ebp)
  800814:	ff 75 08             	pushl  0x8(%ebp)
  800817:	e8 00 fb ff ff       	call   80031c <printnum>
  80081c:	83 c4 20             	add    $0x20,%esp
			break;
  80081f:	eb 34                	jmp    800855 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800821:	83 ec 08             	sub    $0x8,%esp
  800824:	ff 75 0c             	pushl  0xc(%ebp)
  800827:	53                   	push   %ebx
  800828:	8b 45 08             	mov    0x8(%ebp),%eax
  80082b:	ff d0                	call   *%eax
  80082d:	83 c4 10             	add    $0x10,%esp
			break;
  800830:	eb 23                	jmp    800855 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800832:	83 ec 08             	sub    $0x8,%esp
  800835:	ff 75 0c             	pushl  0xc(%ebp)
  800838:	6a 25                	push   $0x25
  80083a:	8b 45 08             	mov    0x8(%ebp),%eax
  80083d:	ff d0                	call   *%eax
  80083f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800842:	ff 4d 10             	decl   0x10(%ebp)
  800845:	eb 03                	jmp    80084a <vprintfmt+0x3b1>
  800847:	ff 4d 10             	decl   0x10(%ebp)
  80084a:	8b 45 10             	mov    0x10(%ebp),%eax
  80084d:	48                   	dec    %eax
  80084e:	8a 00                	mov    (%eax),%al
  800850:	3c 25                	cmp    $0x25,%al
  800852:	75 f3                	jne    800847 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800854:	90                   	nop
		}
	}
  800855:	e9 47 fc ff ff       	jmp    8004a1 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80085a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80085b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80085e:	5b                   	pop    %ebx
  80085f:	5e                   	pop    %esi
  800860:	5d                   	pop    %ebp
  800861:	c3                   	ret    

00800862 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800862:	55                   	push   %ebp
  800863:	89 e5                	mov    %esp,%ebp
  800865:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800868:	8d 45 10             	lea    0x10(%ebp),%eax
  80086b:	83 c0 04             	add    $0x4,%eax
  80086e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800871:	8b 45 10             	mov    0x10(%ebp),%eax
  800874:	ff 75 f4             	pushl  -0xc(%ebp)
  800877:	50                   	push   %eax
  800878:	ff 75 0c             	pushl  0xc(%ebp)
  80087b:	ff 75 08             	pushl  0x8(%ebp)
  80087e:	e8 16 fc ff ff       	call   800499 <vprintfmt>
  800883:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800886:	90                   	nop
  800887:	c9                   	leave  
  800888:	c3                   	ret    

00800889 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800889:	55                   	push   %ebp
  80088a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80088c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80088f:	8b 40 08             	mov    0x8(%eax),%eax
  800892:	8d 50 01             	lea    0x1(%eax),%edx
  800895:	8b 45 0c             	mov    0xc(%ebp),%eax
  800898:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80089b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80089e:	8b 10                	mov    (%eax),%edx
  8008a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a3:	8b 40 04             	mov    0x4(%eax),%eax
  8008a6:	39 c2                	cmp    %eax,%edx
  8008a8:	73 12                	jae    8008bc <sprintputch+0x33>
		*b->buf++ = ch;
  8008aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ad:	8b 00                	mov    (%eax),%eax
  8008af:	8d 48 01             	lea    0x1(%eax),%ecx
  8008b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b5:	89 0a                	mov    %ecx,(%edx)
  8008b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8008ba:	88 10                	mov    %dl,(%eax)
}
  8008bc:	90                   	nop
  8008bd:	5d                   	pop    %ebp
  8008be:	c3                   	ret    

008008bf <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008bf:	55                   	push   %ebp
  8008c0:	89 e5                	mov    %esp,%ebp
  8008c2:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ce:	8d 50 ff             	lea    -0x1(%eax),%edx
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	01 d0                	add    %edx,%eax
  8008d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008e4:	74 06                	je     8008ec <vsnprintf+0x2d>
  8008e6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ea:	7f 07                	jg     8008f3 <vsnprintf+0x34>
		return -E_INVAL;
  8008ec:	b8 03 00 00 00       	mov    $0x3,%eax
  8008f1:	eb 20                	jmp    800913 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008f3:	ff 75 14             	pushl  0x14(%ebp)
  8008f6:	ff 75 10             	pushl  0x10(%ebp)
  8008f9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008fc:	50                   	push   %eax
  8008fd:	68 89 08 80 00       	push   $0x800889
  800902:	e8 92 fb ff ff       	call   800499 <vprintfmt>
  800907:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80090a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80090d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800910:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800913:	c9                   	leave  
  800914:	c3                   	ret    

00800915 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800915:	55                   	push   %ebp
  800916:	89 e5                	mov    %esp,%ebp
  800918:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80091b:	8d 45 10             	lea    0x10(%ebp),%eax
  80091e:	83 c0 04             	add    $0x4,%eax
  800921:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800924:	8b 45 10             	mov    0x10(%ebp),%eax
  800927:	ff 75 f4             	pushl  -0xc(%ebp)
  80092a:	50                   	push   %eax
  80092b:	ff 75 0c             	pushl  0xc(%ebp)
  80092e:	ff 75 08             	pushl  0x8(%ebp)
  800931:	e8 89 ff ff ff       	call   8008bf <vsnprintf>
  800936:	83 c4 10             	add    $0x10,%esp
  800939:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80093c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80093f:	c9                   	leave  
  800940:	c3                   	ret    

00800941 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800941:	55                   	push   %ebp
  800942:	89 e5                	mov    %esp,%ebp
  800944:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800947:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80094e:	eb 06                	jmp    800956 <strlen+0x15>
		n++;
  800950:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800953:	ff 45 08             	incl   0x8(%ebp)
  800956:	8b 45 08             	mov    0x8(%ebp),%eax
  800959:	8a 00                	mov    (%eax),%al
  80095b:	84 c0                	test   %al,%al
  80095d:	75 f1                	jne    800950 <strlen+0xf>
		n++;
	return n;
  80095f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800962:	c9                   	leave  
  800963:	c3                   	ret    

00800964 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800964:	55                   	push   %ebp
  800965:	89 e5                	mov    %esp,%ebp
  800967:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80096a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800971:	eb 09                	jmp    80097c <strnlen+0x18>
		n++;
  800973:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800976:	ff 45 08             	incl   0x8(%ebp)
  800979:	ff 4d 0c             	decl   0xc(%ebp)
  80097c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800980:	74 09                	je     80098b <strnlen+0x27>
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	8a 00                	mov    (%eax),%al
  800987:	84 c0                	test   %al,%al
  800989:	75 e8                	jne    800973 <strnlen+0xf>
		n++;
	return n;
  80098b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80098e:	c9                   	leave  
  80098f:	c3                   	ret    

00800990 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800990:	55                   	push   %ebp
  800991:	89 e5                	mov    %esp,%ebp
  800993:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800996:	8b 45 08             	mov    0x8(%ebp),%eax
  800999:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80099c:	90                   	nop
  80099d:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a0:	8d 50 01             	lea    0x1(%eax),%edx
  8009a3:	89 55 08             	mov    %edx,0x8(%ebp)
  8009a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009ac:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009af:	8a 12                	mov    (%edx),%dl
  8009b1:	88 10                	mov    %dl,(%eax)
  8009b3:	8a 00                	mov    (%eax),%al
  8009b5:	84 c0                	test   %al,%al
  8009b7:	75 e4                	jne    80099d <strcpy+0xd>
		/* do nothing */;
	return ret;
  8009b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009bc:	c9                   	leave  
  8009bd:	c3                   	ret    

008009be <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8009be:	55                   	push   %ebp
  8009bf:	89 e5                	mov    %esp,%ebp
  8009c1:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8009c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8009ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009d1:	eb 1f                	jmp    8009f2 <strncpy+0x34>
		*dst++ = *src;
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	8d 50 01             	lea    0x1(%eax),%edx
  8009d9:	89 55 08             	mov    %edx,0x8(%ebp)
  8009dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009df:	8a 12                	mov    (%edx),%dl
  8009e1:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8009e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e6:	8a 00                	mov    (%eax),%al
  8009e8:	84 c0                	test   %al,%al
  8009ea:	74 03                	je     8009ef <strncpy+0x31>
			src++;
  8009ec:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009ef:	ff 45 fc             	incl   -0x4(%ebp)
  8009f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009f5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8009f8:	72 d9                	jb     8009d3 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8009fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8009fd:	c9                   	leave  
  8009fe:	c3                   	ret    

008009ff <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8009ff:	55                   	push   %ebp
  800a00:	89 e5                	mov    %esp,%ebp
  800a02:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a05:	8b 45 08             	mov    0x8(%ebp),%eax
  800a08:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a0b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a0f:	74 30                	je     800a41 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a11:	eb 16                	jmp    800a29 <strlcpy+0x2a>
			*dst++ = *src++;
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	8d 50 01             	lea    0x1(%eax),%edx
  800a19:	89 55 08             	mov    %edx,0x8(%ebp)
  800a1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a1f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a22:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a25:	8a 12                	mov    (%edx),%dl
  800a27:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a29:	ff 4d 10             	decl   0x10(%ebp)
  800a2c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a30:	74 09                	je     800a3b <strlcpy+0x3c>
  800a32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a35:	8a 00                	mov    (%eax),%al
  800a37:	84 c0                	test   %al,%al
  800a39:	75 d8                	jne    800a13 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a41:	8b 55 08             	mov    0x8(%ebp),%edx
  800a44:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a47:	29 c2                	sub    %eax,%edx
  800a49:	89 d0                	mov    %edx,%eax
}
  800a4b:	c9                   	leave  
  800a4c:	c3                   	ret    

00800a4d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a4d:	55                   	push   %ebp
  800a4e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a50:	eb 06                	jmp    800a58 <strcmp+0xb>
		p++, q++;
  800a52:	ff 45 08             	incl   0x8(%ebp)
  800a55:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a58:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5b:	8a 00                	mov    (%eax),%al
  800a5d:	84 c0                	test   %al,%al
  800a5f:	74 0e                	je     800a6f <strcmp+0x22>
  800a61:	8b 45 08             	mov    0x8(%ebp),%eax
  800a64:	8a 10                	mov    (%eax),%dl
  800a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a69:	8a 00                	mov    (%eax),%al
  800a6b:	38 c2                	cmp    %al,%dl
  800a6d:	74 e3                	je     800a52 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a72:	8a 00                	mov    (%eax),%al
  800a74:	0f b6 d0             	movzbl %al,%edx
  800a77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7a:	8a 00                	mov    (%eax),%al
  800a7c:	0f b6 c0             	movzbl %al,%eax
  800a7f:	29 c2                	sub    %eax,%edx
  800a81:	89 d0                	mov    %edx,%eax
}
  800a83:	5d                   	pop    %ebp
  800a84:	c3                   	ret    

00800a85 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a85:	55                   	push   %ebp
  800a86:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a88:	eb 09                	jmp    800a93 <strncmp+0xe>
		n--, p++, q++;
  800a8a:	ff 4d 10             	decl   0x10(%ebp)
  800a8d:	ff 45 08             	incl   0x8(%ebp)
  800a90:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a93:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a97:	74 17                	je     800ab0 <strncmp+0x2b>
  800a99:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9c:	8a 00                	mov    (%eax),%al
  800a9e:	84 c0                	test   %al,%al
  800aa0:	74 0e                	je     800ab0 <strncmp+0x2b>
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	8a 10                	mov    (%eax),%dl
  800aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aaa:	8a 00                	mov    (%eax),%al
  800aac:	38 c2                	cmp    %al,%dl
  800aae:	74 da                	je     800a8a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ab0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ab4:	75 07                	jne    800abd <strncmp+0x38>
		return 0;
  800ab6:	b8 00 00 00 00       	mov    $0x0,%eax
  800abb:	eb 14                	jmp    800ad1 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800abd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac0:	8a 00                	mov    (%eax),%al
  800ac2:	0f b6 d0             	movzbl %al,%edx
  800ac5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac8:	8a 00                	mov    (%eax),%al
  800aca:	0f b6 c0             	movzbl %al,%eax
  800acd:	29 c2                	sub    %eax,%edx
  800acf:	89 d0                	mov    %edx,%eax
}
  800ad1:	5d                   	pop    %ebp
  800ad2:	c3                   	ret    

00800ad3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ad3:	55                   	push   %ebp
  800ad4:	89 e5                	mov    %esp,%ebp
  800ad6:	83 ec 04             	sub    $0x4,%esp
  800ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800adf:	eb 12                	jmp    800af3 <strchr+0x20>
		if (*s == c)
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	8a 00                	mov    (%eax),%al
  800ae6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ae9:	75 05                	jne    800af0 <strchr+0x1d>
			return (char *) s;
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	eb 11                	jmp    800b01 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800af0:	ff 45 08             	incl   0x8(%ebp)
  800af3:	8b 45 08             	mov    0x8(%ebp),%eax
  800af6:	8a 00                	mov    (%eax),%al
  800af8:	84 c0                	test   %al,%al
  800afa:	75 e5                	jne    800ae1 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800afc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b01:	c9                   	leave  
  800b02:	c3                   	ret    

00800b03 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b03:	55                   	push   %ebp
  800b04:	89 e5                	mov    %esp,%ebp
  800b06:	83 ec 04             	sub    $0x4,%esp
  800b09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b0f:	eb 0d                	jmp    800b1e <strfind+0x1b>
		if (*s == c)
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
  800b14:	8a 00                	mov    (%eax),%al
  800b16:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b19:	74 0e                	je     800b29 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b1b:	ff 45 08             	incl   0x8(%ebp)
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	8a 00                	mov    (%eax),%al
  800b23:	84 c0                	test   %al,%al
  800b25:	75 ea                	jne    800b11 <strfind+0xe>
  800b27:	eb 01                	jmp    800b2a <strfind+0x27>
		if (*s == c)
			break;
  800b29:	90                   	nop
	return (char *) s;
  800b2a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b2d:	c9                   	leave  
  800b2e:	c3                   	ret    

00800b2f <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800b2f:	55                   	push   %ebp
  800b30:	89 e5                	mov    %esp,%ebp
  800b32:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800b35:	8b 45 08             	mov    0x8(%ebp),%eax
  800b38:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b3e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b41:	eb 0e                	jmp    800b51 <memset+0x22>
		*p++ = c;
  800b43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b46:	8d 50 01             	lea    0x1(%eax),%edx
  800b49:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b4f:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b51:	ff 4d f8             	decl   -0x8(%ebp)
  800b54:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b58:	79 e9                	jns    800b43 <memset+0x14>
		*p++ = c;

	return v;
  800b5a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b5d:	c9                   	leave  
  800b5e:	c3                   	ret    

00800b5f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b5f:	55                   	push   %ebp
  800b60:	89 e5                	mov    %esp,%ebp
  800b62:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b71:	eb 16                	jmp    800b89 <memcpy+0x2a>
		*d++ = *s++;
  800b73:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b76:	8d 50 01             	lea    0x1(%eax),%edx
  800b79:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b7c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b7f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b82:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b85:	8a 12                	mov    (%edx),%dl
  800b87:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b89:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b8f:	89 55 10             	mov    %edx,0x10(%ebp)
  800b92:	85 c0                	test   %eax,%eax
  800b94:	75 dd                	jne    800b73 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b96:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b99:	c9                   	leave  
  800b9a:	c3                   	ret    

00800b9b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b9b:	55                   	push   %ebp
  800b9c:	89 e5                	mov    %esp,%ebp
  800b9e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800bad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bb0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bb3:	73 50                	jae    800c05 <memmove+0x6a>
  800bb5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bb8:	8b 45 10             	mov    0x10(%ebp),%eax
  800bbb:	01 d0                	add    %edx,%eax
  800bbd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bc0:	76 43                	jbe    800c05 <memmove+0x6a>
		s += n;
  800bc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc5:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800bc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800bcb:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800bce:	eb 10                	jmp    800be0 <memmove+0x45>
			*--d = *--s;
  800bd0:	ff 4d f8             	decl   -0x8(%ebp)
  800bd3:	ff 4d fc             	decl   -0x4(%ebp)
  800bd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bd9:	8a 10                	mov    (%eax),%dl
  800bdb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bde:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800be0:	8b 45 10             	mov    0x10(%ebp),%eax
  800be3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800be6:	89 55 10             	mov    %edx,0x10(%ebp)
  800be9:	85 c0                	test   %eax,%eax
  800beb:	75 e3                	jne    800bd0 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bed:	eb 23                	jmp    800c12 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800bef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bf2:	8d 50 01             	lea    0x1(%eax),%edx
  800bf5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bf8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bfb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bfe:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c01:	8a 12                	mov    (%edx),%dl
  800c03:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c05:	8b 45 10             	mov    0x10(%ebp),%eax
  800c08:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c0b:	89 55 10             	mov    %edx,0x10(%ebp)
  800c0e:	85 c0                	test   %eax,%eax
  800c10:	75 dd                	jne    800bef <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c12:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c15:	c9                   	leave  
  800c16:	c3                   	ret    

00800c17 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800c17:	55                   	push   %ebp
  800c18:	89 e5                	mov    %esp,%ebp
  800c1a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c20:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800c23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c26:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800c29:	eb 2a                	jmp    800c55 <memcmp+0x3e>
		if (*s1 != *s2)
  800c2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c2e:	8a 10                	mov    (%eax),%dl
  800c30:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c33:	8a 00                	mov    (%eax),%al
  800c35:	38 c2                	cmp    %al,%dl
  800c37:	74 16                	je     800c4f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c3c:	8a 00                	mov    (%eax),%al
  800c3e:	0f b6 d0             	movzbl %al,%edx
  800c41:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c44:	8a 00                	mov    (%eax),%al
  800c46:	0f b6 c0             	movzbl %al,%eax
  800c49:	29 c2                	sub    %eax,%edx
  800c4b:	89 d0                	mov    %edx,%eax
  800c4d:	eb 18                	jmp    800c67 <memcmp+0x50>
		s1++, s2++;
  800c4f:	ff 45 fc             	incl   -0x4(%ebp)
  800c52:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c55:	8b 45 10             	mov    0x10(%ebp),%eax
  800c58:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c5b:	89 55 10             	mov    %edx,0x10(%ebp)
  800c5e:	85 c0                	test   %eax,%eax
  800c60:	75 c9                	jne    800c2b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c67:	c9                   	leave  
  800c68:	c3                   	ret    

00800c69 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c72:	8b 45 10             	mov    0x10(%ebp),%eax
  800c75:	01 d0                	add    %edx,%eax
  800c77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c7a:	eb 15                	jmp    800c91 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	8a 00                	mov    (%eax),%al
  800c81:	0f b6 d0             	movzbl %al,%edx
  800c84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c87:	0f b6 c0             	movzbl %al,%eax
  800c8a:	39 c2                	cmp    %eax,%edx
  800c8c:	74 0d                	je     800c9b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c8e:	ff 45 08             	incl   0x8(%ebp)
  800c91:	8b 45 08             	mov    0x8(%ebp),%eax
  800c94:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c97:	72 e3                	jb     800c7c <memfind+0x13>
  800c99:	eb 01                	jmp    800c9c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c9b:	90                   	nop
	return (void *) s;
  800c9c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c9f:	c9                   	leave  
  800ca0:	c3                   	ret    

00800ca1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ca1:	55                   	push   %ebp
  800ca2:	89 e5                	mov    %esp,%ebp
  800ca4:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ca7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800cae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cb5:	eb 03                	jmp    800cba <strtol+0x19>
		s++;
  800cb7:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	8a 00                	mov    (%eax),%al
  800cbf:	3c 20                	cmp    $0x20,%al
  800cc1:	74 f4                	je     800cb7 <strtol+0x16>
  800cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc6:	8a 00                	mov    (%eax),%al
  800cc8:	3c 09                	cmp    $0x9,%al
  800cca:	74 eb                	je     800cb7 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	8a 00                	mov    (%eax),%al
  800cd1:	3c 2b                	cmp    $0x2b,%al
  800cd3:	75 05                	jne    800cda <strtol+0x39>
		s++;
  800cd5:	ff 45 08             	incl   0x8(%ebp)
  800cd8:	eb 13                	jmp    800ced <strtol+0x4c>
	else if (*s == '-')
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	3c 2d                	cmp    $0x2d,%al
  800ce1:	75 0a                	jne    800ced <strtol+0x4c>
		s++, neg = 1;
  800ce3:	ff 45 08             	incl   0x8(%ebp)
  800ce6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ced:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf1:	74 06                	je     800cf9 <strtol+0x58>
  800cf3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800cf7:	75 20                	jne    800d19 <strtol+0x78>
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	8a 00                	mov    (%eax),%al
  800cfe:	3c 30                	cmp    $0x30,%al
  800d00:	75 17                	jne    800d19 <strtol+0x78>
  800d02:	8b 45 08             	mov    0x8(%ebp),%eax
  800d05:	40                   	inc    %eax
  800d06:	8a 00                	mov    (%eax),%al
  800d08:	3c 78                	cmp    $0x78,%al
  800d0a:	75 0d                	jne    800d19 <strtol+0x78>
		s += 2, base = 16;
  800d0c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d10:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d17:	eb 28                	jmp    800d41 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800d19:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1d:	75 15                	jne    800d34 <strtol+0x93>
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	8a 00                	mov    (%eax),%al
  800d24:	3c 30                	cmp    $0x30,%al
  800d26:	75 0c                	jne    800d34 <strtol+0x93>
		s++, base = 8;
  800d28:	ff 45 08             	incl   0x8(%ebp)
  800d2b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d32:	eb 0d                	jmp    800d41 <strtol+0xa0>
	else if (base == 0)
  800d34:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d38:	75 07                	jne    800d41 <strtol+0xa0>
		base = 10;
  800d3a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	8a 00                	mov    (%eax),%al
  800d46:	3c 2f                	cmp    $0x2f,%al
  800d48:	7e 19                	jle    800d63 <strtol+0xc2>
  800d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4d:	8a 00                	mov    (%eax),%al
  800d4f:	3c 39                	cmp    $0x39,%al
  800d51:	7f 10                	jg     800d63 <strtol+0xc2>
			dig = *s - '0';
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	8a 00                	mov    (%eax),%al
  800d58:	0f be c0             	movsbl %al,%eax
  800d5b:	83 e8 30             	sub    $0x30,%eax
  800d5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d61:	eb 42                	jmp    800da5 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	8a 00                	mov    (%eax),%al
  800d68:	3c 60                	cmp    $0x60,%al
  800d6a:	7e 19                	jle    800d85 <strtol+0xe4>
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	8a 00                	mov    (%eax),%al
  800d71:	3c 7a                	cmp    $0x7a,%al
  800d73:	7f 10                	jg     800d85 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	8a 00                	mov    (%eax),%al
  800d7a:	0f be c0             	movsbl %al,%eax
  800d7d:	83 e8 57             	sub    $0x57,%eax
  800d80:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d83:	eb 20                	jmp    800da5 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
  800d88:	8a 00                	mov    (%eax),%al
  800d8a:	3c 40                	cmp    $0x40,%al
  800d8c:	7e 39                	jle    800dc7 <strtol+0x126>
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	8a 00                	mov    (%eax),%al
  800d93:	3c 5a                	cmp    $0x5a,%al
  800d95:	7f 30                	jg     800dc7 <strtol+0x126>
			dig = *s - 'A' + 10;
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	8a 00                	mov    (%eax),%al
  800d9c:	0f be c0             	movsbl %al,%eax
  800d9f:	83 e8 37             	sub    $0x37,%eax
  800da2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800da8:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dab:	7d 19                	jge    800dc6 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800dad:	ff 45 08             	incl   0x8(%ebp)
  800db0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800db3:	0f af 45 10          	imul   0x10(%ebp),%eax
  800db7:	89 c2                	mov    %eax,%edx
  800db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dbc:	01 d0                	add    %edx,%eax
  800dbe:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800dc1:	e9 7b ff ff ff       	jmp    800d41 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800dc6:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800dc7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dcb:	74 08                	je     800dd5 <strtol+0x134>
		*endptr = (char *) s;
  800dcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd0:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd3:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800dd5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800dd9:	74 07                	je     800de2 <strtol+0x141>
  800ddb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dde:	f7 d8                	neg    %eax
  800de0:	eb 03                	jmp    800de5 <strtol+0x144>
  800de2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800de5:	c9                   	leave  
  800de6:	c3                   	ret    

00800de7 <ltostr>:

void
ltostr(long value, char *str)
{
  800de7:	55                   	push   %ebp
  800de8:	89 e5                	mov    %esp,%ebp
  800dea:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800ded:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800df4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800dfb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dff:	79 13                	jns    800e14 <ltostr+0x2d>
	{
		neg = 1;
  800e01:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e0e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e11:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800e1c:	99                   	cltd   
  800e1d:	f7 f9                	idiv   %ecx
  800e1f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800e22:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e25:	8d 50 01             	lea    0x1(%eax),%edx
  800e28:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e2b:	89 c2                	mov    %eax,%edx
  800e2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e30:	01 d0                	add    %edx,%eax
  800e32:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e35:	83 c2 30             	add    $0x30,%edx
  800e38:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e3a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e3d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e42:	f7 e9                	imul   %ecx
  800e44:	c1 fa 02             	sar    $0x2,%edx
  800e47:	89 c8                	mov    %ecx,%eax
  800e49:	c1 f8 1f             	sar    $0x1f,%eax
  800e4c:	29 c2                	sub    %eax,%edx
  800e4e:	89 d0                	mov    %edx,%eax
  800e50:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800e53:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e56:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e5b:	f7 e9                	imul   %ecx
  800e5d:	c1 fa 02             	sar    $0x2,%edx
  800e60:	89 c8                	mov    %ecx,%eax
  800e62:	c1 f8 1f             	sar    $0x1f,%eax
  800e65:	29 c2                	sub    %eax,%edx
  800e67:	89 d0                	mov    %edx,%eax
  800e69:	c1 e0 02             	shl    $0x2,%eax
  800e6c:	01 d0                	add    %edx,%eax
  800e6e:	01 c0                	add    %eax,%eax
  800e70:	29 c1                	sub    %eax,%ecx
  800e72:	89 ca                	mov    %ecx,%edx
  800e74:	85 d2                	test   %edx,%edx
  800e76:	75 9c                	jne    800e14 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e82:	48                   	dec    %eax
  800e83:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e86:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e8a:	74 3d                	je     800ec9 <ltostr+0xe2>
		start = 1 ;
  800e8c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e93:	eb 34                	jmp    800ec9 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800e95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9b:	01 d0                	add    %edx,%eax
  800e9d:	8a 00                	mov    (%eax),%al
  800e9f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800ea2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ea5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea8:	01 c2                	add    %eax,%edx
  800eaa:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800ead:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb0:	01 c8                	add    %ecx,%eax
  800eb2:	8a 00                	mov    (%eax),%al
  800eb4:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800eb6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800eb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebc:	01 c2                	add    %eax,%edx
  800ebe:	8a 45 eb             	mov    -0x15(%ebp),%al
  800ec1:	88 02                	mov    %al,(%edx)
		start++ ;
  800ec3:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800ec6:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ecc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ecf:	7c c4                	jl     800e95 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800ed1:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800ed4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed7:	01 d0                	add    %edx,%eax
  800ed9:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800edc:	90                   	nop
  800edd:	c9                   	leave  
  800ede:	c3                   	ret    

00800edf <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800edf:	55                   	push   %ebp
  800ee0:	89 e5                	mov    %esp,%ebp
  800ee2:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800ee5:	ff 75 08             	pushl  0x8(%ebp)
  800ee8:	e8 54 fa ff ff       	call   800941 <strlen>
  800eed:	83 c4 04             	add    $0x4,%esp
  800ef0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800ef3:	ff 75 0c             	pushl  0xc(%ebp)
  800ef6:	e8 46 fa ff ff       	call   800941 <strlen>
  800efb:	83 c4 04             	add    $0x4,%esp
  800efe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f01:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f08:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f0f:	eb 17                	jmp    800f28 <strcconcat+0x49>
		final[s] = str1[s] ;
  800f11:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f14:	8b 45 10             	mov    0x10(%ebp),%eax
  800f17:	01 c2                	add    %eax,%edx
  800f19:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	01 c8                	add    %ecx,%eax
  800f21:	8a 00                	mov    (%eax),%al
  800f23:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800f25:	ff 45 fc             	incl   -0x4(%ebp)
  800f28:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f2e:	7c e1                	jl     800f11 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800f30:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800f37:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f3e:	eb 1f                	jmp    800f5f <strcconcat+0x80>
		final[s++] = str2[i] ;
  800f40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f43:	8d 50 01             	lea    0x1(%eax),%edx
  800f46:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f49:	89 c2                	mov    %eax,%edx
  800f4b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4e:	01 c2                	add    %eax,%edx
  800f50:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f56:	01 c8                	add    %ecx,%eax
  800f58:	8a 00                	mov    (%eax),%al
  800f5a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f5c:	ff 45 f8             	incl   -0x8(%ebp)
  800f5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f62:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f65:	7c d9                	jl     800f40 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f67:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6d:	01 d0                	add    %edx,%eax
  800f6f:	c6 00 00             	movb   $0x0,(%eax)
}
  800f72:	90                   	nop
  800f73:	c9                   	leave  
  800f74:	c3                   	ret    

00800f75 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f75:	55                   	push   %ebp
  800f76:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f78:	8b 45 14             	mov    0x14(%ebp),%eax
  800f7b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f81:	8b 45 14             	mov    0x14(%ebp),%eax
  800f84:	8b 00                	mov    (%eax),%eax
  800f86:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f8d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f90:	01 d0                	add    %edx,%eax
  800f92:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f98:	eb 0c                	jmp    800fa6 <strsplit+0x31>
			*string++ = 0;
  800f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9d:	8d 50 01             	lea    0x1(%eax),%edx
  800fa0:	89 55 08             	mov    %edx,0x8(%ebp)
  800fa3:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa9:	8a 00                	mov    (%eax),%al
  800fab:	84 c0                	test   %al,%al
  800fad:	74 18                	je     800fc7 <strsplit+0x52>
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	8a 00                	mov    (%eax),%al
  800fb4:	0f be c0             	movsbl %al,%eax
  800fb7:	50                   	push   %eax
  800fb8:	ff 75 0c             	pushl  0xc(%ebp)
  800fbb:	e8 13 fb ff ff       	call   800ad3 <strchr>
  800fc0:	83 c4 08             	add    $0x8,%esp
  800fc3:	85 c0                	test   %eax,%eax
  800fc5:	75 d3                	jne    800f9a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	8a 00                	mov    (%eax),%al
  800fcc:	84 c0                	test   %al,%al
  800fce:	74 5a                	je     80102a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800fd0:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd3:	8b 00                	mov    (%eax),%eax
  800fd5:	83 f8 0f             	cmp    $0xf,%eax
  800fd8:	75 07                	jne    800fe1 <strsplit+0x6c>
		{
			return 0;
  800fda:	b8 00 00 00 00       	mov    $0x0,%eax
  800fdf:	eb 66                	jmp    801047 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800fe1:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe4:	8b 00                	mov    (%eax),%eax
  800fe6:	8d 48 01             	lea    0x1(%eax),%ecx
  800fe9:	8b 55 14             	mov    0x14(%ebp),%edx
  800fec:	89 0a                	mov    %ecx,(%edx)
  800fee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ff5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff8:	01 c2                	add    %eax,%edx
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fff:	eb 03                	jmp    801004 <strsplit+0x8f>
			string++;
  801001:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	8a 00                	mov    (%eax),%al
  801009:	84 c0                	test   %al,%al
  80100b:	74 8b                	je     800f98 <strsplit+0x23>
  80100d:	8b 45 08             	mov    0x8(%ebp),%eax
  801010:	8a 00                	mov    (%eax),%al
  801012:	0f be c0             	movsbl %al,%eax
  801015:	50                   	push   %eax
  801016:	ff 75 0c             	pushl  0xc(%ebp)
  801019:	e8 b5 fa ff ff       	call   800ad3 <strchr>
  80101e:	83 c4 08             	add    $0x8,%esp
  801021:	85 c0                	test   %eax,%eax
  801023:	74 dc                	je     801001 <strsplit+0x8c>
			string++;
	}
  801025:	e9 6e ff ff ff       	jmp    800f98 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80102a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80102b:	8b 45 14             	mov    0x14(%ebp),%eax
  80102e:	8b 00                	mov    (%eax),%eax
  801030:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801037:	8b 45 10             	mov    0x10(%ebp),%eax
  80103a:	01 d0                	add    %edx,%eax
  80103c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801042:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801047:	c9                   	leave  
  801048:	c3                   	ret    

00801049 <malloc>:
int sizeofarray=0;
uint32 addresses[100000];
int changed[100000];
int numOfPages[100000];
void* malloc(uint32 size)
{
  801049:	55                   	push   %ebp
  80104a:	89 e5                	mov    %esp,%ebp
  80104c:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
		// Write your code here, remove the panic and write your code
		int num = size /PAGE_SIZE;
  80104f:	8b 45 08             	mov    0x8(%ebp),%eax
  801052:	c1 e8 0c             	shr    $0xc,%eax
  801055:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 return_addres;

		if(size%PAGE_SIZE!=0)
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	25 ff 0f 00 00       	and    $0xfff,%eax
  801060:	85 c0                	test   %eax,%eax
  801062:	74 03                	je     801067 <malloc+0x1e>
			num++;
  801064:	ff 45 f4             	incl   -0xc(%ebp)
		if(last_addres==USER_HEAP_START)
  801067:	a1 04 30 80 00       	mov    0x803004,%eax
  80106c:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  801071:	75 73                	jne    8010e6 <malloc+0x9d>
		{
			sys_allocateMem(USER_HEAP_START,size);
  801073:	83 ec 08             	sub    $0x8,%esp
  801076:	ff 75 08             	pushl  0x8(%ebp)
  801079:	68 00 00 00 80       	push   $0x80000000
  80107e:	e8 13 05 00 00       	call   801596 <sys_allocateMem>
  801083:	83 c4 10             	add    $0x10,%esp
			return_addres=last_addres;
  801086:	a1 04 30 80 00       	mov    0x803004,%eax
  80108b:	89 45 d8             	mov    %eax,-0x28(%ebp)
			last_addres+=num*PAGE_SIZE;
  80108e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801091:	c1 e0 0c             	shl    $0xc,%eax
  801094:	89 c2                	mov    %eax,%edx
  801096:	a1 04 30 80 00       	mov    0x803004,%eax
  80109b:	01 d0                	add    %edx,%eax
  80109d:	a3 04 30 80 00       	mov    %eax,0x803004
			numOfPages[sizeofarray]=num;
  8010a2:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8010a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010aa:	89 14 85 40 66 cc 06 	mov    %edx,0x6cc6640(,%eax,4)
			addresses[sizeofarray]=last_addres;
  8010b1:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8010b6:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8010bc:	89 14 85 40 31 c0 06 	mov    %edx,0x6c03140(,%eax,4)
			changed[sizeofarray]=1;
  8010c3:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8010c8:	c7 04 85 c0 4b c6 06 	movl   $0x1,0x6c64bc0(,%eax,4)
  8010cf:	01 00 00 00 
			sizeofarray++;
  8010d3:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8010d8:	40                   	inc    %eax
  8010d9:	a3 2c 30 80 00       	mov    %eax,0x80302c
			return (void*)return_addres;
  8010de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8010e1:	e9 71 01 00 00       	jmp    801257 <malloc+0x20e>
		}
		else
		{
			if(changes==0)
  8010e6:	a1 28 30 80 00       	mov    0x803028,%eax
  8010eb:	85 c0                	test   %eax,%eax
  8010ed:	75 71                	jne    801160 <malloc+0x117>
			{
				sys_allocateMem(last_addres,size);
  8010ef:	a1 04 30 80 00       	mov    0x803004,%eax
  8010f4:	83 ec 08             	sub    $0x8,%esp
  8010f7:	ff 75 08             	pushl  0x8(%ebp)
  8010fa:	50                   	push   %eax
  8010fb:	e8 96 04 00 00       	call   801596 <sys_allocateMem>
  801100:	83 c4 10             	add    $0x10,%esp
				return_addres=last_addres;
  801103:	a1 04 30 80 00       	mov    0x803004,%eax
  801108:	89 45 d8             	mov    %eax,-0x28(%ebp)
				last_addres+=num*PAGE_SIZE;
  80110b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80110e:	c1 e0 0c             	shl    $0xc,%eax
  801111:	89 c2                	mov    %eax,%edx
  801113:	a1 04 30 80 00       	mov    0x803004,%eax
  801118:	01 d0                	add    %edx,%eax
  80111a:	a3 04 30 80 00       	mov    %eax,0x803004
				numOfPages[sizeofarray]=num;
  80111f:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801124:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801127:	89 14 85 40 66 cc 06 	mov    %edx,0x6cc6640(,%eax,4)
				addresses[sizeofarray]=return_addres;
  80112e:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801133:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801136:	89 14 85 40 31 c0 06 	mov    %edx,0x6c03140(,%eax,4)
				changed[sizeofarray]=1;
  80113d:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801142:	c7 04 85 c0 4b c6 06 	movl   $0x1,0x6c64bc0(,%eax,4)
  801149:	01 00 00 00 
				sizeofarray++;
  80114d:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801152:	40                   	inc    %eax
  801153:	a3 2c 30 80 00       	mov    %eax,0x80302c
				return (void*)return_addres;
  801158:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80115b:	e9 f7 00 00 00       	jmp    801257 <malloc+0x20e>
			}
			else{
				int count=0;
  801160:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
				int min=1000;
  801167:	c7 45 ec e8 03 00 00 	movl   $0x3e8,-0x14(%ebp)
				int index=-1;
  80116e:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
				uint32 min_addresss;
				for(uint32 i=USER_HEAP_START;i<USER_HEAP_MAX;i+=PAGE_SIZE)
  801175:	c7 45 e0 00 00 00 80 	movl   $0x80000000,-0x20(%ebp)
  80117c:	eb 7c                	jmp    8011fa <malloc+0x1b1>
				{
					uint32 *pg=NULL;
  80117e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					for(int j=0;j<sizeofarray;j++)
  801185:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80118c:	eb 1a                	jmp    8011a8 <malloc+0x15f>
					{
						if(addresses[j]==i)
  80118e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801191:	8b 04 85 40 31 c0 06 	mov    0x6c03140(,%eax,4),%eax
  801198:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80119b:	75 08                	jne    8011a5 <malloc+0x15c>
						{
							index=j;
  80119d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011a0:	89 45 e8             	mov    %eax,-0x18(%ebp)
							break;
  8011a3:	eb 0d                	jmp    8011b2 <malloc+0x169>
				int index=-1;
				uint32 min_addresss;
				for(uint32 i=USER_HEAP_START;i<USER_HEAP_MAX;i+=PAGE_SIZE)
				{
					uint32 *pg=NULL;
					for(int j=0;j<sizeofarray;j++)
  8011a5:	ff 45 dc             	incl   -0x24(%ebp)
  8011a8:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8011ad:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  8011b0:	7c dc                	jl     80118e <malloc+0x145>
							index=j;
							break;
						}
					}

					if(index==-1)
  8011b2:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  8011b6:	75 05                	jne    8011bd <malloc+0x174>
					{
						count++;
  8011b8:	ff 45 f0             	incl   -0x10(%ebp)
  8011bb:	eb 36                	jmp    8011f3 <malloc+0x1aa>
					}
					else
					{
						if(changed[index]==0)
  8011bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8011c0:	8b 04 85 c0 4b c6 06 	mov    0x6c64bc0(,%eax,4),%eax
  8011c7:	85 c0                	test   %eax,%eax
  8011c9:	75 05                	jne    8011d0 <malloc+0x187>
						{
							count++;
  8011cb:	ff 45 f0             	incl   -0x10(%ebp)
  8011ce:	eb 23                	jmp    8011f3 <malloc+0x1aa>
						}
						else
						{
							if(count<min&&count>=num)
  8011d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011d3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8011d6:	7d 14                	jge    8011ec <malloc+0x1a3>
  8011d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011db:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011de:	7c 0c                	jl     8011ec <malloc+0x1a3>
							{
								min=count;
  8011e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
								min_addresss=i;
  8011e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
							}
							count=0;
  8011ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			else{
				int count=0;
				int min=1000;
				int index=-1;
				uint32 min_addresss;
				for(uint32 i=USER_HEAP_START;i<USER_HEAP_MAX;i+=PAGE_SIZE)
  8011f3:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  8011fa:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  801201:	0f 86 77 ff ff ff    	jbe    80117e <malloc+0x135>

					}

					}

				sys_allocateMem(min_addresss,size);
  801207:	83 ec 08             	sub    $0x8,%esp
  80120a:	ff 75 08             	pushl  0x8(%ebp)
  80120d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801210:	e8 81 03 00 00       	call   801596 <sys_allocateMem>
  801215:	83 c4 10             	add    $0x10,%esp
				numOfPages[sizeofarray]=num;
  801218:	a1 2c 30 80 00       	mov    0x80302c,%eax
  80121d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801220:	89 14 85 40 66 cc 06 	mov    %edx,0x6cc6640(,%eax,4)
				addresses[sizeofarray]=last_addres;
  801227:	a1 2c 30 80 00       	mov    0x80302c,%eax
  80122c:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801232:	89 14 85 40 31 c0 06 	mov    %edx,0x6c03140(,%eax,4)
				changed[sizeofarray]=1;
  801239:	a1 2c 30 80 00       	mov    0x80302c,%eax
  80123e:	c7 04 85 c0 4b c6 06 	movl   $0x1,0x6c64bc0(,%eax,4)
  801245:	01 00 00 00 
				sizeofarray++;
  801249:	a1 2c 30 80 00       	mov    0x80302c,%eax
  80124e:	40                   	inc    %eax
  80124f:	a3 2c 30 80 00       	mov    %eax,0x80302c
				return(void*) min_addresss;
  801254:	8b 45 e4             	mov    -0x1c(%ebp),%eax

		//refer to the project presentation and documentation for details

		return NULL;

}
  801257:	c9                   	leave  
  801258:	c3                   	ret    

00801259 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801259:	55                   	push   %ebp
  80125a:	89 e5                	mov    %esp,%ebp
  80125c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code
	//you should get the size of the given allocation using its address
    uint32 va=(uint32)virtual_address;
  80125f:	8b 45 08             	mov    0x8(%ebp),%eax
  801262:	89 45 e8             	mov    %eax,-0x18(%ebp)
    uint32 size;
    int is_found=0;
  801265:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int index;
    for(int i=0;i<sizeofarray;i++){
  80126c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801273:	eb 30                	jmp    8012a5 <free+0x4c>
    	if(addresses[i]==va&&changed[i]==1){
  801275:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801278:	8b 04 85 40 31 c0 06 	mov    0x6c03140(,%eax,4),%eax
  80127f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801282:	75 1e                	jne    8012a2 <free+0x49>
  801284:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801287:	8b 04 85 c0 4b c6 06 	mov    0x6c64bc0(,%eax,4),%eax
  80128e:	83 f8 01             	cmp    $0x1,%eax
  801291:	75 0f                	jne    8012a2 <free+0x49>
    		is_found=1;
  801293:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    		index=i;
  80129a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80129d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    		break;
  8012a0:	eb 0d                	jmp    8012af <free+0x56>
	//you should get the size of the given allocation using its address
    uint32 va=(uint32)virtual_address;
    uint32 size;
    int is_found=0;
    int index;
    for(int i=0;i<sizeofarray;i++){
  8012a2:	ff 45 ec             	incl   -0x14(%ebp)
  8012a5:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8012aa:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8012ad:	7c c6                	jl     801275 <free+0x1c>
    		is_found=1;
    		index=i;
    		break;
    	}
    }
    if(is_found==1){
  8012af:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  8012b3:	75 3a                	jne    8012ef <free+0x96>
    	size=numOfPages[index]*PAGE_SIZE;
  8012b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012b8:	8b 04 85 40 66 cc 06 	mov    0x6cc6640(,%eax,4),%eax
  8012bf:	c1 e0 0c             	shl    $0xc,%eax
  8012c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    	sys_freeMem(va,size);
  8012c5:	83 ec 08             	sub    $0x8,%esp
  8012c8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012cb:	ff 75 e8             	pushl  -0x18(%ebp)
  8012ce:	e8 a7 02 00 00       	call   80157a <sys_freeMem>
  8012d3:	83 c4 10             	add    $0x10,%esp
    	changed[index]=0;
  8012d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012d9:	c7 04 85 c0 4b c6 06 	movl   $0x0,0x6c64bc0(,%eax,4)
  8012e0:	00 00 00 00 
    	changes++;
  8012e4:	a1 28 30 80 00       	mov    0x803028,%eax
  8012e9:	40                   	inc    %eax
  8012ea:	a3 28 30 80 00       	mov    %eax,0x803028
    }


	//refer to the project presentation and documentation for details
}
  8012ef:	90                   	nop
  8012f0:	c9                   	leave  
  8012f1:	c3                   	ret    

008012f2 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8012f2:	55                   	push   %ebp
  8012f3:	89 e5                	mov    %esp,%ebp
  8012f5:	83 ec 18             	sub    $0x18,%esp
  8012f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012fb:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  8012fe:	83 ec 04             	sub    $0x4,%esp
  801301:	68 d0 23 80 00       	push   $0x8023d0
  801306:	68 9f 00 00 00       	push   $0x9f
  80130b:	68 f3 23 80 00       	push   $0x8023f3
  801310:	e8 bf 07 00 00       	call   801ad4 <_panic>

00801315 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801315:	55                   	push   %ebp
  801316:	89 e5                	mov    %esp,%ebp
  801318:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80131b:	83 ec 04             	sub    $0x4,%esp
  80131e:	68 d0 23 80 00       	push   $0x8023d0
  801323:	68 a5 00 00 00       	push   $0xa5
  801328:	68 f3 23 80 00       	push   $0x8023f3
  80132d:	e8 a2 07 00 00       	call   801ad4 <_panic>

00801332 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801332:	55                   	push   %ebp
  801333:	89 e5                	mov    %esp,%ebp
  801335:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801338:	83 ec 04             	sub    $0x4,%esp
  80133b:	68 d0 23 80 00       	push   $0x8023d0
  801340:	68 ab 00 00 00       	push   $0xab
  801345:	68 f3 23 80 00       	push   $0x8023f3
  80134a:	e8 85 07 00 00       	call   801ad4 <_panic>

0080134f <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  80134f:	55                   	push   %ebp
  801350:	89 e5                	mov    %esp,%ebp
  801352:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801355:	83 ec 04             	sub    $0x4,%esp
  801358:	68 d0 23 80 00       	push   $0x8023d0
  80135d:	68 b0 00 00 00       	push   $0xb0
  801362:	68 f3 23 80 00       	push   $0x8023f3
  801367:	e8 68 07 00 00       	call   801ad4 <_panic>

0080136c <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  80136c:	55                   	push   %ebp
  80136d:	89 e5                	mov    %esp,%ebp
  80136f:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801372:	83 ec 04             	sub    $0x4,%esp
  801375:	68 d0 23 80 00       	push   $0x8023d0
  80137a:	68 b6 00 00 00       	push   $0xb6
  80137f:	68 f3 23 80 00       	push   $0x8023f3
  801384:	e8 4b 07 00 00       	call   801ad4 <_panic>

00801389 <shrink>:
}
void shrink(uint32 newSize)
{
  801389:	55                   	push   %ebp
  80138a:	89 e5                	mov    %esp,%ebp
  80138c:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80138f:	83 ec 04             	sub    $0x4,%esp
  801392:	68 d0 23 80 00       	push   $0x8023d0
  801397:	68 ba 00 00 00       	push   $0xba
  80139c:	68 f3 23 80 00       	push   $0x8023f3
  8013a1:	e8 2e 07 00 00       	call   801ad4 <_panic>

008013a6 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
  8013a9:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8013ac:	83 ec 04             	sub    $0x4,%esp
  8013af:	68 d0 23 80 00       	push   $0x8023d0
  8013b4:	68 bf 00 00 00       	push   $0xbf
  8013b9:	68 f3 23 80 00       	push   $0x8023f3
  8013be:	e8 11 07 00 00       	call   801ad4 <_panic>

008013c3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8013c3:	55                   	push   %ebp
  8013c4:	89 e5                	mov    %esp,%ebp
  8013c6:	57                   	push   %edi
  8013c7:	56                   	push   %esi
  8013c8:	53                   	push   %ebx
  8013c9:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013d2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013d5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013d8:	8b 7d 18             	mov    0x18(%ebp),%edi
  8013db:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8013de:	cd 30                	int    $0x30
  8013e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8013e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8013e6:	83 c4 10             	add    $0x10,%esp
  8013e9:	5b                   	pop    %ebx
  8013ea:	5e                   	pop    %esi
  8013eb:	5f                   	pop    %edi
  8013ec:	5d                   	pop    %ebp
  8013ed:	c3                   	ret    

008013ee <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8013ee:	55                   	push   %ebp
  8013ef:	89 e5                	mov    %esp,%ebp
  8013f1:	83 ec 04             	sub    $0x4,%esp
  8013f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8013fa:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8013fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801401:	6a 00                	push   $0x0
  801403:	6a 00                	push   $0x0
  801405:	52                   	push   %edx
  801406:	ff 75 0c             	pushl  0xc(%ebp)
  801409:	50                   	push   %eax
  80140a:	6a 00                	push   $0x0
  80140c:	e8 b2 ff ff ff       	call   8013c3 <syscall>
  801411:	83 c4 18             	add    $0x18,%esp
}
  801414:	90                   	nop
  801415:	c9                   	leave  
  801416:	c3                   	ret    

00801417 <sys_cgetc>:

int
sys_cgetc(void)
{
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80141a:	6a 00                	push   $0x0
  80141c:	6a 00                	push   $0x0
  80141e:	6a 00                	push   $0x0
  801420:	6a 00                	push   $0x0
  801422:	6a 00                	push   $0x0
  801424:	6a 01                	push   $0x1
  801426:	e8 98 ff ff ff       	call   8013c3 <syscall>
  80142b:	83 c4 18             	add    $0x18,%esp
}
  80142e:	c9                   	leave  
  80142f:	c3                   	ret    

00801430 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801430:	55                   	push   %ebp
  801431:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801433:	8b 45 08             	mov    0x8(%ebp),%eax
  801436:	6a 00                	push   $0x0
  801438:	6a 00                	push   $0x0
  80143a:	6a 00                	push   $0x0
  80143c:	6a 00                	push   $0x0
  80143e:	50                   	push   %eax
  80143f:	6a 05                	push   $0x5
  801441:	e8 7d ff ff ff       	call   8013c3 <syscall>
  801446:	83 c4 18             	add    $0x18,%esp
}
  801449:	c9                   	leave  
  80144a:	c3                   	ret    

0080144b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80144b:	55                   	push   %ebp
  80144c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80144e:	6a 00                	push   $0x0
  801450:	6a 00                	push   $0x0
  801452:	6a 00                	push   $0x0
  801454:	6a 00                	push   $0x0
  801456:	6a 00                	push   $0x0
  801458:	6a 02                	push   $0x2
  80145a:	e8 64 ff ff ff       	call   8013c3 <syscall>
  80145f:	83 c4 18             	add    $0x18,%esp
}
  801462:	c9                   	leave  
  801463:	c3                   	ret    

00801464 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801464:	55                   	push   %ebp
  801465:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801467:	6a 00                	push   $0x0
  801469:	6a 00                	push   $0x0
  80146b:	6a 00                	push   $0x0
  80146d:	6a 00                	push   $0x0
  80146f:	6a 00                	push   $0x0
  801471:	6a 03                	push   $0x3
  801473:	e8 4b ff ff ff       	call   8013c3 <syscall>
  801478:	83 c4 18             	add    $0x18,%esp
}
  80147b:	c9                   	leave  
  80147c:	c3                   	ret    

0080147d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80147d:	55                   	push   %ebp
  80147e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801480:	6a 00                	push   $0x0
  801482:	6a 00                	push   $0x0
  801484:	6a 00                	push   $0x0
  801486:	6a 00                	push   $0x0
  801488:	6a 00                	push   $0x0
  80148a:	6a 04                	push   $0x4
  80148c:	e8 32 ff ff ff       	call   8013c3 <syscall>
  801491:	83 c4 18             	add    $0x18,%esp
}
  801494:	c9                   	leave  
  801495:	c3                   	ret    

00801496 <sys_env_exit>:


void sys_env_exit(void)
{
  801496:	55                   	push   %ebp
  801497:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801499:	6a 00                	push   $0x0
  80149b:	6a 00                	push   $0x0
  80149d:	6a 00                	push   $0x0
  80149f:	6a 00                	push   $0x0
  8014a1:	6a 00                	push   $0x0
  8014a3:	6a 06                	push   $0x6
  8014a5:	e8 19 ff ff ff       	call   8013c3 <syscall>
  8014aa:	83 c4 18             	add    $0x18,%esp
}
  8014ad:	90                   	nop
  8014ae:	c9                   	leave  
  8014af:	c3                   	ret    

008014b0 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8014b0:	55                   	push   %ebp
  8014b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8014b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b9:	6a 00                	push   $0x0
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 00                	push   $0x0
  8014bf:	52                   	push   %edx
  8014c0:	50                   	push   %eax
  8014c1:	6a 07                	push   $0x7
  8014c3:	e8 fb fe ff ff       	call   8013c3 <syscall>
  8014c8:	83 c4 18             	add    $0x18,%esp
}
  8014cb:	c9                   	leave  
  8014cc:	c3                   	ret    

008014cd <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8014cd:	55                   	push   %ebp
  8014ce:	89 e5                	mov    %esp,%ebp
  8014d0:	56                   	push   %esi
  8014d1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8014d2:	8b 75 18             	mov    0x18(%ebp),%esi
  8014d5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014de:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e1:	56                   	push   %esi
  8014e2:	53                   	push   %ebx
  8014e3:	51                   	push   %ecx
  8014e4:	52                   	push   %edx
  8014e5:	50                   	push   %eax
  8014e6:	6a 08                	push   $0x8
  8014e8:	e8 d6 fe ff ff       	call   8013c3 <syscall>
  8014ed:	83 c4 18             	add    $0x18,%esp
}
  8014f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014f3:	5b                   	pop    %ebx
  8014f4:	5e                   	pop    %esi
  8014f5:	5d                   	pop    %ebp
  8014f6:	c3                   	ret    

008014f7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8014f7:	55                   	push   %ebp
  8014f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8014fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801500:	6a 00                	push   $0x0
  801502:	6a 00                	push   $0x0
  801504:	6a 00                	push   $0x0
  801506:	52                   	push   %edx
  801507:	50                   	push   %eax
  801508:	6a 09                	push   $0x9
  80150a:	e8 b4 fe ff ff       	call   8013c3 <syscall>
  80150f:	83 c4 18             	add    $0x18,%esp
}
  801512:	c9                   	leave  
  801513:	c3                   	ret    

00801514 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801517:	6a 00                	push   $0x0
  801519:	6a 00                	push   $0x0
  80151b:	6a 00                	push   $0x0
  80151d:	ff 75 0c             	pushl  0xc(%ebp)
  801520:	ff 75 08             	pushl  0x8(%ebp)
  801523:	6a 0a                	push   $0xa
  801525:	e8 99 fe ff ff       	call   8013c3 <syscall>
  80152a:	83 c4 18             	add    $0x18,%esp
}
  80152d:	c9                   	leave  
  80152e:	c3                   	ret    

0080152f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80152f:	55                   	push   %ebp
  801530:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801532:	6a 00                	push   $0x0
  801534:	6a 00                	push   $0x0
  801536:	6a 00                	push   $0x0
  801538:	6a 00                	push   $0x0
  80153a:	6a 00                	push   $0x0
  80153c:	6a 0b                	push   $0xb
  80153e:	e8 80 fe ff ff       	call   8013c3 <syscall>
  801543:	83 c4 18             	add    $0x18,%esp
}
  801546:	c9                   	leave  
  801547:	c3                   	ret    

00801548 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801548:	55                   	push   %ebp
  801549:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80154b:	6a 00                	push   $0x0
  80154d:	6a 00                	push   $0x0
  80154f:	6a 00                	push   $0x0
  801551:	6a 00                	push   $0x0
  801553:	6a 00                	push   $0x0
  801555:	6a 0c                	push   $0xc
  801557:	e8 67 fe ff ff       	call   8013c3 <syscall>
  80155c:	83 c4 18             	add    $0x18,%esp
}
  80155f:	c9                   	leave  
  801560:	c3                   	ret    

00801561 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801564:	6a 00                	push   $0x0
  801566:	6a 00                	push   $0x0
  801568:	6a 00                	push   $0x0
  80156a:	6a 00                	push   $0x0
  80156c:	6a 00                	push   $0x0
  80156e:	6a 0d                	push   $0xd
  801570:	e8 4e fe ff ff       	call   8013c3 <syscall>
  801575:	83 c4 18             	add    $0x18,%esp
}
  801578:	c9                   	leave  
  801579:	c3                   	ret    

0080157a <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  80157d:	6a 00                	push   $0x0
  80157f:	6a 00                	push   $0x0
  801581:	6a 00                	push   $0x0
  801583:	ff 75 0c             	pushl  0xc(%ebp)
  801586:	ff 75 08             	pushl  0x8(%ebp)
  801589:	6a 11                	push   $0x11
  80158b:	e8 33 fe ff ff       	call   8013c3 <syscall>
  801590:	83 c4 18             	add    $0x18,%esp
	return;
  801593:	90                   	nop
}
  801594:	c9                   	leave  
  801595:	c3                   	ret    

00801596 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	ff 75 0c             	pushl  0xc(%ebp)
  8015a2:	ff 75 08             	pushl  0x8(%ebp)
  8015a5:	6a 12                	push   $0x12
  8015a7:	e8 17 fe ff ff       	call   8013c3 <syscall>
  8015ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8015af:	90                   	nop
}
  8015b0:	c9                   	leave  
  8015b1:	c3                   	ret    

008015b2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 0e                	push   $0xe
  8015c1:	e8 fd fd ff ff       	call   8013c3 <syscall>
  8015c6:	83 c4 18             	add    $0x18,%esp
}
  8015c9:	c9                   	leave  
  8015ca:	c3                   	ret    

008015cb <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015cb:	55                   	push   %ebp
  8015cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 00                	push   $0x0
  8015d6:	ff 75 08             	pushl  0x8(%ebp)
  8015d9:	6a 0f                	push   $0xf
  8015db:	e8 e3 fd ff ff       	call   8013c3 <syscall>
  8015e0:	83 c4 18             	add    $0x18,%esp
}
  8015e3:	c9                   	leave  
  8015e4:	c3                   	ret    

008015e5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8015e5:	55                   	push   %ebp
  8015e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 10                	push   $0x10
  8015f4:	e8 ca fd ff ff       	call   8013c3 <syscall>
  8015f9:	83 c4 18             	add    $0x18,%esp
}
  8015fc:	90                   	nop
  8015fd:	c9                   	leave  
  8015fe:	c3                   	ret    

008015ff <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	6a 00                	push   $0x0
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	6a 14                	push   $0x14
  80160e:	e8 b0 fd ff ff       	call   8013c3 <syscall>
  801613:	83 c4 18             	add    $0x18,%esp
}
  801616:	90                   	nop
  801617:	c9                   	leave  
  801618:	c3                   	ret    

00801619 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80161c:	6a 00                	push   $0x0
  80161e:	6a 00                	push   $0x0
  801620:	6a 00                	push   $0x0
  801622:	6a 00                	push   $0x0
  801624:	6a 00                	push   $0x0
  801626:	6a 15                	push   $0x15
  801628:	e8 96 fd ff ff       	call   8013c3 <syscall>
  80162d:	83 c4 18             	add    $0x18,%esp
}
  801630:	90                   	nop
  801631:	c9                   	leave  
  801632:	c3                   	ret    

00801633 <sys_cputc>:


void
sys_cputc(const char c)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	83 ec 04             	sub    $0x4,%esp
  801639:	8b 45 08             	mov    0x8(%ebp),%eax
  80163c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80163f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801643:	6a 00                	push   $0x0
  801645:	6a 00                	push   $0x0
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	50                   	push   %eax
  80164c:	6a 16                	push   $0x16
  80164e:	e8 70 fd ff ff       	call   8013c3 <syscall>
  801653:	83 c4 18             	add    $0x18,%esp
}
  801656:	90                   	nop
  801657:	c9                   	leave  
  801658:	c3                   	ret    

00801659 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	6a 17                	push   $0x17
  801668:	e8 56 fd ff ff       	call   8013c3 <syscall>
  80166d:	83 c4 18             	add    $0x18,%esp
}
  801670:	90                   	nop
  801671:	c9                   	leave  
  801672:	c3                   	ret    

00801673 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801673:	55                   	push   %ebp
  801674:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	6a 00                	push   $0x0
  80167f:	ff 75 0c             	pushl  0xc(%ebp)
  801682:	50                   	push   %eax
  801683:	6a 18                	push   $0x18
  801685:	e8 39 fd ff ff       	call   8013c3 <syscall>
  80168a:	83 c4 18             	add    $0x18,%esp
}
  80168d:	c9                   	leave  
  80168e:	c3                   	ret    

0080168f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80168f:	55                   	push   %ebp
  801690:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801692:	8b 55 0c             	mov    0xc(%ebp),%edx
  801695:	8b 45 08             	mov    0x8(%ebp),%eax
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	52                   	push   %edx
  80169f:	50                   	push   %eax
  8016a0:	6a 1b                	push   $0x1b
  8016a2:	e8 1c fd ff ff       	call   8013c3 <syscall>
  8016a7:	83 c4 18             	add    $0x18,%esp
}
  8016aa:	c9                   	leave  
  8016ab:	c3                   	ret    

008016ac <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	52                   	push   %edx
  8016bc:	50                   	push   %eax
  8016bd:	6a 19                	push   $0x19
  8016bf:	e8 ff fc ff ff       	call   8013c3 <syscall>
  8016c4:	83 c4 18             	add    $0x18,%esp
}
  8016c7:	90                   	nop
  8016c8:	c9                   	leave  
  8016c9:	c3                   	ret    

008016ca <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8016ca:	55                   	push   %ebp
  8016cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 00                	push   $0x0
  8016d9:	52                   	push   %edx
  8016da:	50                   	push   %eax
  8016db:	6a 1a                	push   $0x1a
  8016dd:	e8 e1 fc ff ff       	call   8013c3 <syscall>
  8016e2:	83 c4 18             	add    $0x18,%esp
}
  8016e5:	90                   	nop
  8016e6:	c9                   	leave  
  8016e7:	c3                   	ret    

008016e8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
  8016eb:	83 ec 04             	sub    $0x4,%esp
  8016ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8016f4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016f7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fe:	6a 00                	push   $0x0
  801700:	51                   	push   %ecx
  801701:	52                   	push   %edx
  801702:	ff 75 0c             	pushl  0xc(%ebp)
  801705:	50                   	push   %eax
  801706:	6a 1c                	push   $0x1c
  801708:	e8 b6 fc ff ff       	call   8013c3 <syscall>
  80170d:	83 c4 18             	add    $0x18,%esp
}
  801710:	c9                   	leave  
  801711:	c3                   	ret    

00801712 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801715:	8b 55 0c             	mov    0xc(%ebp),%edx
  801718:	8b 45 08             	mov    0x8(%ebp),%eax
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	52                   	push   %edx
  801722:	50                   	push   %eax
  801723:	6a 1d                	push   $0x1d
  801725:	e8 99 fc ff ff       	call   8013c3 <syscall>
  80172a:	83 c4 18             	add    $0x18,%esp
}
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    

0080172f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801732:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801735:	8b 55 0c             	mov    0xc(%ebp),%edx
  801738:	8b 45 08             	mov    0x8(%ebp),%eax
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	51                   	push   %ecx
  801740:	52                   	push   %edx
  801741:	50                   	push   %eax
  801742:	6a 1e                	push   $0x1e
  801744:	e8 7a fc ff ff       	call   8013c3 <syscall>
  801749:	83 c4 18             	add    $0x18,%esp
}
  80174c:	c9                   	leave  
  80174d:	c3                   	ret    

0080174e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801751:	8b 55 0c             	mov    0xc(%ebp),%edx
  801754:	8b 45 08             	mov    0x8(%ebp),%eax
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	52                   	push   %edx
  80175e:	50                   	push   %eax
  80175f:	6a 1f                	push   $0x1f
  801761:	e8 5d fc ff ff       	call   8013c3 <syscall>
  801766:	83 c4 18             	add    $0x18,%esp
}
  801769:	c9                   	leave  
  80176a:	c3                   	ret    

0080176b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 20                	push   $0x20
  80177a:	e8 44 fc ff ff       	call   8013c3 <syscall>
  80177f:	83 c4 18             	add    $0x18,%esp
}
  801782:	c9                   	leave  
  801783:	c3                   	ret    

00801784 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801784:	55                   	push   %ebp
  801785:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801787:	8b 45 08             	mov    0x8(%ebp),%eax
  80178a:	6a 00                	push   $0x0
  80178c:	ff 75 14             	pushl  0x14(%ebp)
  80178f:	ff 75 10             	pushl  0x10(%ebp)
  801792:	ff 75 0c             	pushl  0xc(%ebp)
  801795:	50                   	push   %eax
  801796:	6a 21                	push   $0x21
  801798:	e8 26 fc ff ff       	call   8013c3 <syscall>
  80179d:	83 c4 18             	add    $0x18,%esp
}
  8017a0:	c9                   	leave  
  8017a1:	c3                   	ret    

008017a2 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8017a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	50                   	push   %eax
  8017b1:	6a 22                	push   $0x22
  8017b3:	e8 0b fc ff ff       	call   8013c3 <syscall>
  8017b8:	83 c4 18             	add    $0x18,%esp
}
  8017bb:	90                   	nop
  8017bc:	c9                   	leave  
  8017bd:	c3                   	ret    

008017be <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8017c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	50                   	push   %eax
  8017cd:	6a 23                	push   $0x23
  8017cf:	e8 ef fb ff ff       	call   8013c3 <syscall>
  8017d4:	83 c4 18             	add    $0x18,%esp
}
  8017d7:	90                   	nop
  8017d8:	c9                   	leave  
  8017d9:	c3                   	ret    

008017da <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
  8017dd:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8017e0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017e3:	8d 50 04             	lea    0x4(%eax),%edx
  8017e6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	52                   	push   %edx
  8017f0:	50                   	push   %eax
  8017f1:	6a 24                	push   $0x24
  8017f3:	e8 cb fb ff ff       	call   8013c3 <syscall>
  8017f8:	83 c4 18             	add    $0x18,%esp
	return result;
  8017fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801801:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801804:	89 01                	mov    %eax,(%ecx)
  801806:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801809:	8b 45 08             	mov    0x8(%ebp),%eax
  80180c:	c9                   	leave  
  80180d:	c2 04 00             	ret    $0x4

00801810 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	ff 75 10             	pushl  0x10(%ebp)
  80181a:	ff 75 0c             	pushl  0xc(%ebp)
  80181d:	ff 75 08             	pushl  0x8(%ebp)
  801820:	6a 13                	push   $0x13
  801822:	e8 9c fb ff ff       	call   8013c3 <syscall>
  801827:	83 c4 18             	add    $0x18,%esp
	return ;
  80182a:	90                   	nop
}
  80182b:	c9                   	leave  
  80182c:	c3                   	ret    

0080182d <sys_rcr2>:
uint32 sys_rcr2()
{
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 25                	push   $0x25
  80183c:	e8 82 fb ff ff       	call   8013c3 <syscall>
  801841:	83 c4 18             	add    $0x18,%esp
}
  801844:	c9                   	leave  
  801845:	c3                   	ret    

00801846 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
  801849:	83 ec 04             	sub    $0x4,%esp
  80184c:	8b 45 08             	mov    0x8(%ebp),%eax
  80184f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801852:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	50                   	push   %eax
  80185f:	6a 26                	push   $0x26
  801861:	e8 5d fb ff ff       	call   8013c3 <syscall>
  801866:	83 c4 18             	add    $0x18,%esp
	return ;
  801869:	90                   	nop
}
  80186a:	c9                   	leave  
  80186b:	c3                   	ret    

0080186c <rsttst>:
void rsttst()
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 28                	push   $0x28
  80187b:	e8 43 fb ff ff       	call   8013c3 <syscall>
  801880:	83 c4 18             	add    $0x18,%esp
	return ;
  801883:	90                   	nop
}
  801884:	c9                   	leave  
  801885:	c3                   	ret    

00801886 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
  801889:	83 ec 04             	sub    $0x4,%esp
  80188c:	8b 45 14             	mov    0x14(%ebp),%eax
  80188f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801892:	8b 55 18             	mov    0x18(%ebp),%edx
  801895:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801899:	52                   	push   %edx
  80189a:	50                   	push   %eax
  80189b:	ff 75 10             	pushl  0x10(%ebp)
  80189e:	ff 75 0c             	pushl  0xc(%ebp)
  8018a1:	ff 75 08             	pushl  0x8(%ebp)
  8018a4:	6a 27                	push   $0x27
  8018a6:	e8 18 fb ff ff       	call   8013c3 <syscall>
  8018ab:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ae:	90                   	nop
}
  8018af:	c9                   	leave  
  8018b0:	c3                   	ret    

008018b1 <chktst>:
void chktst(uint32 n)
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	ff 75 08             	pushl  0x8(%ebp)
  8018bf:	6a 29                	push   $0x29
  8018c1:	e8 fd fa ff ff       	call   8013c3 <syscall>
  8018c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8018c9:	90                   	nop
}
  8018ca:	c9                   	leave  
  8018cb:	c3                   	ret    

008018cc <inctst>:

void inctst()
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 2a                	push   $0x2a
  8018db:	e8 e3 fa ff ff       	call   8013c3 <syscall>
  8018e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8018e3:	90                   	nop
}
  8018e4:	c9                   	leave  
  8018e5:	c3                   	ret    

008018e6 <gettst>:
uint32 gettst()
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 2b                	push   $0x2b
  8018f5:	e8 c9 fa ff ff       	call   8013c3 <syscall>
  8018fa:	83 c4 18             	add    $0x18,%esp
}
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    

008018ff <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
  801902:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 2c                	push   $0x2c
  801911:	e8 ad fa ff ff       	call   8013c3 <syscall>
  801916:	83 c4 18             	add    $0x18,%esp
  801919:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80191c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801920:	75 07                	jne    801929 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801922:	b8 01 00 00 00       	mov    $0x1,%eax
  801927:	eb 05                	jmp    80192e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801929:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80192e:	c9                   	leave  
  80192f:	c3                   	ret    

00801930 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
  801933:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 2c                	push   $0x2c
  801942:	e8 7c fa ff ff       	call   8013c3 <syscall>
  801947:	83 c4 18             	add    $0x18,%esp
  80194a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80194d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801951:	75 07                	jne    80195a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801953:	b8 01 00 00 00       	mov    $0x1,%eax
  801958:	eb 05                	jmp    80195f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80195a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80195f:	c9                   	leave  
  801960:	c3                   	ret    

00801961 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
  801964:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 2c                	push   $0x2c
  801973:	e8 4b fa ff ff       	call   8013c3 <syscall>
  801978:	83 c4 18             	add    $0x18,%esp
  80197b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80197e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801982:	75 07                	jne    80198b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801984:	b8 01 00 00 00       	mov    $0x1,%eax
  801989:	eb 05                	jmp    801990 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80198b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801990:	c9                   	leave  
  801991:	c3                   	ret    

00801992 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801992:	55                   	push   %ebp
  801993:	89 e5                	mov    %esp,%ebp
  801995:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 2c                	push   $0x2c
  8019a4:	e8 1a fa ff ff       	call   8013c3 <syscall>
  8019a9:	83 c4 18             	add    $0x18,%esp
  8019ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8019af:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8019b3:	75 07                	jne    8019bc <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8019b5:	b8 01 00 00 00       	mov    $0x1,%eax
  8019ba:	eb 05                	jmp    8019c1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8019bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	ff 75 08             	pushl  0x8(%ebp)
  8019d1:	6a 2d                	push   $0x2d
  8019d3:	e8 eb f9 ff ff       	call   8013c3 <syscall>
  8019d8:	83 c4 18             	add    $0x18,%esp
	return ;
  8019db:	90                   	nop
}
  8019dc:	c9                   	leave  
  8019dd:	c3                   	ret    

008019de <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
  8019e1:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8019e2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ee:	6a 00                	push   $0x0
  8019f0:	53                   	push   %ebx
  8019f1:	51                   	push   %ecx
  8019f2:	52                   	push   %edx
  8019f3:	50                   	push   %eax
  8019f4:	6a 2e                	push   $0x2e
  8019f6:	e8 c8 f9 ff ff       	call   8013c3 <syscall>
  8019fb:	83 c4 18             	add    $0x18,%esp
}
  8019fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    

00801a03 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a09:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	52                   	push   %edx
  801a13:	50                   	push   %eax
  801a14:	6a 2f                	push   $0x2f
  801a16:	e8 a8 f9 ff ff       	call   8013c3 <syscall>
  801a1b:	83 c4 18             	add    $0x18,%esp
}
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
  801a23:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801a26:	8b 55 08             	mov    0x8(%ebp),%edx
  801a29:	89 d0                	mov    %edx,%eax
  801a2b:	c1 e0 02             	shl    $0x2,%eax
  801a2e:	01 d0                	add    %edx,%eax
  801a30:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a37:	01 d0                	add    %edx,%eax
  801a39:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a40:	01 d0                	add    %edx,%eax
  801a42:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a49:	01 d0                	add    %edx,%eax
  801a4b:	c1 e0 04             	shl    $0x4,%eax
  801a4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801a51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801a58:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801a5b:	83 ec 0c             	sub    $0xc,%esp
  801a5e:	50                   	push   %eax
  801a5f:	e8 76 fd ff ff       	call   8017da <sys_get_virtual_time>
  801a64:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801a67:	eb 41                	jmp    801aaa <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801a69:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801a6c:	83 ec 0c             	sub    $0xc,%esp
  801a6f:	50                   	push   %eax
  801a70:	e8 65 fd ff ff       	call   8017da <sys_get_virtual_time>
  801a75:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801a78:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a7e:	29 c2                	sub    %eax,%edx
  801a80:	89 d0                	mov    %edx,%eax
  801a82:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801a85:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a8b:	89 d1                	mov    %edx,%ecx
  801a8d:	29 c1                	sub    %eax,%ecx
  801a8f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a92:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a95:	39 c2                	cmp    %eax,%edx
  801a97:	0f 97 c0             	seta   %al
  801a9a:	0f b6 c0             	movzbl %al,%eax
  801a9d:	29 c1                	sub    %eax,%ecx
  801a9f:	89 c8                	mov    %ecx,%eax
  801aa1:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801aa4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801aa7:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aad:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ab0:	72 b7                	jb     801a69 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801ab2:	90                   	nop
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
  801ab8:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801abb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801ac2:	eb 03                	jmp    801ac7 <busy_wait+0x12>
  801ac4:	ff 45 fc             	incl   -0x4(%ebp)
  801ac7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801aca:	3b 45 08             	cmp    0x8(%ebp),%eax
  801acd:	72 f5                	jb     801ac4 <busy_wait+0xf>
	return i;
  801acf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801ad2:	c9                   	leave  
  801ad3:	c3                   	ret    

00801ad4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
  801ad7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801ada:	8d 45 10             	lea    0x10(%ebp),%eax
  801add:	83 c0 04             	add    $0x4,%eax
  801ae0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801ae3:	a1 c0 80 d2 06       	mov    0x6d280c0,%eax
  801ae8:	85 c0                	test   %eax,%eax
  801aea:	74 16                	je     801b02 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801aec:	a1 c0 80 d2 06       	mov    0x6d280c0,%eax
  801af1:	83 ec 08             	sub    $0x8,%esp
  801af4:	50                   	push   %eax
  801af5:	68 00 24 80 00       	push   $0x802400
  801afa:	e8 c0 e7 ff ff       	call   8002bf <cprintf>
  801aff:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801b02:	a1 00 30 80 00       	mov    0x803000,%eax
  801b07:	ff 75 0c             	pushl  0xc(%ebp)
  801b0a:	ff 75 08             	pushl  0x8(%ebp)
  801b0d:	50                   	push   %eax
  801b0e:	68 05 24 80 00       	push   $0x802405
  801b13:	e8 a7 e7 ff ff       	call   8002bf <cprintf>
  801b18:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801b1b:	8b 45 10             	mov    0x10(%ebp),%eax
  801b1e:	83 ec 08             	sub    $0x8,%esp
  801b21:	ff 75 f4             	pushl  -0xc(%ebp)
  801b24:	50                   	push   %eax
  801b25:	e8 2a e7 ff ff       	call   800254 <vcprintf>
  801b2a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801b2d:	83 ec 08             	sub    $0x8,%esp
  801b30:	6a 00                	push   $0x0
  801b32:	68 21 24 80 00       	push   $0x802421
  801b37:	e8 18 e7 ff ff       	call   800254 <vcprintf>
  801b3c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801b3f:	e8 99 e6 ff ff       	call   8001dd <exit>

	// should not return here
	while (1) ;
  801b44:	eb fe                	jmp    801b44 <_panic+0x70>

00801b46 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
  801b49:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801b4c:	a1 20 30 80 00       	mov    0x803020,%eax
  801b51:	8b 50 74             	mov    0x74(%eax),%edx
  801b54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b57:	39 c2                	cmp    %eax,%edx
  801b59:	74 14                	je     801b6f <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801b5b:	83 ec 04             	sub    $0x4,%esp
  801b5e:	68 24 24 80 00       	push   $0x802424
  801b63:	6a 26                	push   $0x26
  801b65:	68 70 24 80 00       	push   $0x802470
  801b6a:	e8 65 ff ff ff       	call   801ad4 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801b6f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801b76:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801b7d:	e9 b6 00 00 00       	jmp    801c38 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  801b82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b85:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8f:	01 d0                	add    %edx,%eax
  801b91:	8b 00                	mov    (%eax),%eax
  801b93:	85 c0                	test   %eax,%eax
  801b95:	75 08                	jne    801b9f <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  801b97:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801b9a:	e9 96 00 00 00       	jmp    801c35 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  801b9f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801ba6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801bad:	eb 5d                	jmp    801c0c <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801baf:	a1 20 30 80 00       	mov    0x803020,%eax
  801bb4:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  801bba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801bbd:	c1 e2 04             	shl    $0x4,%edx
  801bc0:	01 d0                	add    %edx,%eax
  801bc2:	8a 40 04             	mov    0x4(%eax),%al
  801bc5:	84 c0                	test   %al,%al
  801bc7:	75 40                	jne    801c09 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801bc9:	a1 20 30 80 00       	mov    0x803020,%eax
  801bce:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  801bd4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801bd7:	c1 e2 04             	shl    $0x4,%edx
  801bda:	01 d0                	add    %edx,%eax
  801bdc:	8b 00                	mov    (%eax),%eax
  801bde:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801be1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801be4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801be9:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801beb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bee:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf8:	01 c8                	add    %ecx,%eax
  801bfa:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801bfc:	39 c2                	cmp    %eax,%edx
  801bfe:	75 09                	jne    801c09 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  801c00:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801c07:	eb 12                	jmp    801c1b <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801c09:	ff 45 e8             	incl   -0x18(%ebp)
  801c0c:	a1 20 30 80 00       	mov    0x803020,%eax
  801c11:	8b 50 74             	mov    0x74(%eax),%edx
  801c14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c17:	39 c2                	cmp    %eax,%edx
  801c19:	77 94                	ja     801baf <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801c1b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c1f:	75 14                	jne    801c35 <CheckWSWithoutLastIndex+0xef>
			panic(
  801c21:	83 ec 04             	sub    $0x4,%esp
  801c24:	68 7c 24 80 00       	push   $0x80247c
  801c29:	6a 3a                	push   $0x3a
  801c2b:	68 70 24 80 00       	push   $0x802470
  801c30:	e8 9f fe ff ff       	call   801ad4 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801c35:	ff 45 f0             	incl   -0x10(%ebp)
  801c38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c3b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801c3e:	0f 8c 3e ff ff ff    	jl     801b82 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801c44:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801c4b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801c52:	eb 20                	jmp    801c74 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801c54:	a1 20 30 80 00       	mov    0x803020,%eax
  801c59:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  801c5f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c62:	c1 e2 04             	shl    $0x4,%edx
  801c65:	01 d0                	add    %edx,%eax
  801c67:	8a 40 04             	mov    0x4(%eax),%al
  801c6a:	3c 01                	cmp    $0x1,%al
  801c6c:	75 03                	jne    801c71 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  801c6e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801c71:	ff 45 e0             	incl   -0x20(%ebp)
  801c74:	a1 20 30 80 00       	mov    0x803020,%eax
  801c79:	8b 50 74             	mov    0x74(%eax),%edx
  801c7c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c7f:	39 c2                	cmp    %eax,%edx
  801c81:	77 d1                	ja     801c54 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c86:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801c89:	74 14                	je     801c9f <CheckWSWithoutLastIndex+0x159>
		panic(
  801c8b:	83 ec 04             	sub    $0x4,%esp
  801c8e:	68 d0 24 80 00       	push   $0x8024d0
  801c93:	6a 44                	push   $0x44
  801c95:	68 70 24 80 00       	push   $0x802470
  801c9a:	e8 35 fe ff ff       	call   801ad4 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801c9f:	90                   	nop
  801ca0:	c9                   	leave  
  801ca1:	c3                   	ret    
  801ca2:	66 90                	xchg   %ax,%ax

00801ca4 <__udivdi3>:
  801ca4:	55                   	push   %ebp
  801ca5:	57                   	push   %edi
  801ca6:	56                   	push   %esi
  801ca7:	53                   	push   %ebx
  801ca8:	83 ec 1c             	sub    $0x1c,%esp
  801cab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801caf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801cb3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cb7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801cbb:	89 ca                	mov    %ecx,%edx
  801cbd:	89 f8                	mov    %edi,%eax
  801cbf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801cc3:	85 f6                	test   %esi,%esi
  801cc5:	75 2d                	jne    801cf4 <__udivdi3+0x50>
  801cc7:	39 cf                	cmp    %ecx,%edi
  801cc9:	77 65                	ja     801d30 <__udivdi3+0x8c>
  801ccb:	89 fd                	mov    %edi,%ebp
  801ccd:	85 ff                	test   %edi,%edi
  801ccf:	75 0b                	jne    801cdc <__udivdi3+0x38>
  801cd1:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd6:	31 d2                	xor    %edx,%edx
  801cd8:	f7 f7                	div    %edi
  801cda:	89 c5                	mov    %eax,%ebp
  801cdc:	31 d2                	xor    %edx,%edx
  801cde:	89 c8                	mov    %ecx,%eax
  801ce0:	f7 f5                	div    %ebp
  801ce2:	89 c1                	mov    %eax,%ecx
  801ce4:	89 d8                	mov    %ebx,%eax
  801ce6:	f7 f5                	div    %ebp
  801ce8:	89 cf                	mov    %ecx,%edi
  801cea:	89 fa                	mov    %edi,%edx
  801cec:	83 c4 1c             	add    $0x1c,%esp
  801cef:	5b                   	pop    %ebx
  801cf0:	5e                   	pop    %esi
  801cf1:	5f                   	pop    %edi
  801cf2:	5d                   	pop    %ebp
  801cf3:	c3                   	ret    
  801cf4:	39 ce                	cmp    %ecx,%esi
  801cf6:	77 28                	ja     801d20 <__udivdi3+0x7c>
  801cf8:	0f bd fe             	bsr    %esi,%edi
  801cfb:	83 f7 1f             	xor    $0x1f,%edi
  801cfe:	75 40                	jne    801d40 <__udivdi3+0x9c>
  801d00:	39 ce                	cmp    %ecx,%esi
  801d02:	72 0a                	jb     801d0e <__udivdi3+0x6a>
  801d04:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801d08:	0f 87 9e 00 00 00    	ja     801dac <__udivdi3+0x108>
  801d0e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d13:	89 fa                	mov    %edi,%edx
  801d15:	83 c4 1c             	add    $0x1c,%esp
  801d18:	5b                   	pop    %ebx
  801d19:	5e                   	pop    %esi
  801d1a:	5f                   	pop    %edi
  801d1b:	5d                   	pop    %ebp
  801d1c:	c3                   	ret    
  801d1d:	8d 76 00             	lea    0x0(%esi),%esi
  801d20:	31 ff                	xor    %edi,%edi
  801d22:	31 c0                	xor    %eax,%eax
  801d24:	89 fa                	mov    %edi,%edx
  801d26:	83 c4 1c             	add    $0x1c,%esp
  801d29:	5b                   	pop    %ebx
  801d2a:	5e                   	pop    %esi
  801d2b:	5f                   	pop    %edi
  801d2c:	5d                   	pop    %ebp
  801d2d:	c3                   	ret    
  801d2e:	66 90                	xchg   %ax,%ax
  801d30:	89 d8                	mov    %ebx,%eax
  801d32:	f7 f7                	div    %edi
  801d34:	31 ff                	xor    %edi,%edi
  801d36:	89 fa                	mov    %edi,%edx
  801d38:	83 c4 1c             	add    $0x1c,%esp
  801d3b:	5b                   	pop    %ebx
  801d3c:	5e                   	pop    %esi
  801d3d:	5f                   	pop    %edi
  801d3e:	5d                   	pop    %ebp
  801d3f:	c3                   	ret    
  801d40:	bd 20 00 00 00       	mov    $0x20,%ebp
  801d45:	89 eb                	mov    %ebp,%ebx
  801d47:	29 fb                	sub    %edi,%ebx
  801d49:	89 f9                	mov    %edi,%ecx
  801d4b:	d3 e6                	shl    %cl,%esi
  801d4d:	89 c5                	mov    %eax,%ebp
  801d4f:	88 d9                	mov    %bl,%cl
  801d51:	d3 ed                	shr    %cl,%ebp
  801d53:	89 e9                	mov    %ebp,%ecx
  801d55:	09 f1                	or     %esi,%ecx
  801d57:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801d5b:	89 f9                	mov    %edi,%ecx
  801d5d:	d3 e0                	shl    %cl,%eax
  801d5f:	89 c5                	mov    %eax,%ebp
  801d61:	89 d6                	mov    %edx,%esi
  801d63:	88 d9                	mov    %bl,%cl
  801d65:	d3 ee                	shr    %cl,%esi
  801d67:	89 f9                	mov    %edi,%ecx
  801d69:	d3 e2                	shl    %cl,%edx
  801d6b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d6f:	88 d9                	mov    %bl,%cl
  801d71:	d3 e8                	shr    %cl,%eax
  801d73:	09 c2                	or     %eax,%edx
  801d75:	89 d0                	mov    %edx,%eax
  801d77:	89 f2                	mov    %esi,%edx
  801d79:	f7 74 24 0c          	divl   0xc(%esp)
  801d7d:	89 d6                	mov    %edx,%esi
  801d7f:	89 c3                	mov    %eax,%ebx
  801d81:	f7 e5                	mul    %ebp
  801d83:	39 d6                	cmp    %edx,%esi
  801d85:	72 19                	jb     801da0 <__udivdi3+0xfc>
  801d87:	74 0b                	je     801d94 <__udivdi3+0xf0>
  801d89:	89 d8                	mov    %ebx,%eax
  801d8b:	31 ff                	xor    %edi,%edi
  801d8d:	e9 58 ff ff ff       	jmp    801cea <__udivdi3+0x46>
  801d92:	66 90                	xchg   %ax,%ax
  801d94:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d98:	89 f9                	mov    %edi,%ecx
  801d9a:	d3 e2                	shl    %cl,%edx
  801d9c:	39 c2                	cmp    %eax,%edx
  801d9e:	73 e9                	jae    801d89 <__udivdi3+0xe5>
  801da0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801da3:	31 ff                	xor    %edi,%edi
  801da5:	e9 40 ff ff ff       	jmp    801cea <__udivdi3+0x46>
  801daa:	66 90                	xchg   %ax,%ax
  801dac:	31 c0                	xor    %eax,%eax
  801dae:	e9 37 ff ff ff       	jmp    801cea <__udivdi3+0x46>
  801db3:	90                   	nop

00801db4 <__umoddi3>:
  801db4:	55                   	push   %ebp
  801db5:	57                   	push   %edi
  801db6:	56                   	push   %esi
  801db7:	53                   	push   %ebx
  801db8:	83 ec 1c             	sub    $0x1c,%esp
  801dbb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801dbf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801dc3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801dc7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801dcb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801dcf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801dd3:	89 f3                	mov    %esi,%ebx
  801dd5:	89 fa                	mov    %edi,%edx
  801dd7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ddb:	89 34 24             	mov    %esi,(%esp)
  801dde:	85 c0                	test   %eax,%eax
  801de0:	75 1a                	jne    801dfc <__umoddi3+0x48>
  801de2:	39 f7                	cmp    %esi,%edi
  801de4:	0f 86 a2 00 00 00    	jbe    801e8c <__umoddi3+0xd8>
  801dea:	89 c8                	mov    %ecx,%eax
  801dec:	89 f2                	mov    %esi,%edx
  801dee:	f7 f7                	div    %edi
  801df0:	89 d0                	mov    %edx,%eax
  801df2:	31 d2                	xor    %edx,%edx
  801df4:	83 c4 1c             	add    $0x1c,%esp
  801df7:	5b                   	pop    %ebx
  801df8:	5e                   	pop    %esi
  801df9:	5f                   	pop    %edi
  801dfa:	5d                   	pop    %ebp
  801dfb:	c3                   	ret    
  801dfc:	39 f0                	cmp    %esi,%eax
  801dfe:	0f 87 ac 00 00 00    	ja     801eb0 <__umoddi3+0xfc>
  801e04:	0f bd e8             	bsr    %eax,%ebp
  801e07:	83 f5 1f             	xor    $0x1f,%ebp
  801e0a:	0f 84 ac 00 00 00    	je     801ebc <__umoddi3+0x108>
  801e10:	bf 20 00 00 00       	mov    $0x20,%edi
  801e15:	29 ef                	sub    %ebp,%edi
  801e17:	89 fe                	mov    %edi,%esi
  801e19:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801e1d:	89 e9                	mov    %ebp,%ecx
  801e1f:	d3 e0                	shl    %cl,%eax
  801e21:	89 d7                	mov    %edx,%edi
  801e23:	89 f1                	mov    %esi,%ecx
  801e25:	d3 ef                	shr    %cl,%edi
  801e27:	09 c7                	or     %eax,%edi
  801e29:	89 e9                	mov    %ebp,%ecx
  801e2b:	d3 e2                	shl    %cl,%edx
  801e2d:	89 14 24             	mov    %edx,(%esp)
  801e30:	89 d8                	mov    %ebx,%eax
  801e32:	d3 e0                	shl    %cl,%eax
  801e34:	89 c2                	mov    %eax,%edx
  801e36:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e3a:	d3 e0                	shl    %cl,%eax
  801e3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e40:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e44:	89 f1                	mov    %esi,%ecx
  801e46:	d3 e8                	shr    %cl,%eax
  801e48:	09 d0                	or     %edx,%eax
  801e4a:	d3 eb                	shr    %cl,%ebx
  801e4c:	89 da                	mov    %ebx,%edx
  801e4e:	f7 f7                	div    %edi
  801e50:	89 d3                	mov    %edx,%ebx
  801e52:	f7 24 24             	mull   (%esp)
  801e55:	89 c6                	mov    %eax,%esi
  801e57:	89 d1                	mov    %edx,%ecx
  801e59:	39 d3                	cmp    %edx,%ebx
  801e5b:	0f 82 87 00 00 00    	jb     801ee8 <__umoddi3+0x134>
  801e61:	0f 84 91 00 00 00    	je     801ef8 <__umoddi3+0x144>
  801e67:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e6b:	29 f2                	sub    %esi,%edx
  801e6d:	19 cb                	sbb    %ecx,%ebx
  801e6f:	89 d8                	mov    %ebx,%eax
  801e71:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801e75:	d3 e0                	shl    %cl,%eax
  801e77:	89 e9                	mov    %ebp,%ecx
  801e79:	d3 ea                	shr    %cl,%edx
  801e7b:	09 d0                	or     %edx,%eax
  801e7d:	89 e9                	mov    %ebp,%ecx
  801e7f:	d3 eb                	shr    %cl,%ebx
  801e81:	89 da                	mov    %ebx,%edx
  801e83:	83 c4 1c             	add    $0x1c,%esp
  801e86:	5b                   	pop    %ebx
  801e87:	5e                   	pop    %esi
  801e88:	5f                   	pop    %edi
  801e89:	5d                   	pop    %ebp
  801e8a:	c3                   	ret    
  801e8b:	90                   	nop
  801e8c:	89 fd                	mov    %edi,%ebp
  801e8e:	85 ff                	test   %edi,%edi
  801e90:	75 0b                	jne    801e9d <__umoddi3+0xe9>
  801e92:	b8 01 00 00 00       	mov    $0x1,%eax
  801e97:	31 d2                	xor    %edx,%edx
  801e99:	f7 f7                	div    %edi
  801e9b:	89 c5                	mov    %eax,%ebp
  801e9d:	89 f0                	mov    %esi,%eax
  801e9f:	31 d2                	xor    %edx,%edx
  801ea1:	f7 f5                	div    %ebp
  801ea3:	89 c8                	mov    %ecx,%eax
  801ea5:	f7 f5                	div    %ebp
  801ea7:	89 d0                	mov    %edx,%eax
  801ea9:	e9 44 ff ff ff       	jmp    801df2 <__umoddi3+0x3e>
  801eae:	66 90                	xchg   %ax,%ax
  801eb0:	89 c8                	mov    %ecx,%eax
  801eb2:	89 f2                	mov    %esi,%edx
  801eb4:	83 c4 1c             	add    $0x1c,%esp
  801eb7:	5b                   	pop    %ebx
  801eb8:	5e                   	pop    %esi
  801eb9:	5f                   	pop    %edi
  801eba:	5d                   	pop    %ebp
  801ebb:	c3                   	ret    
  801ebc:	3b 04 24             	cmp    (%esp),%eax
  801ebf:	72 06                	jb     801ec7 <__umoddi3+0x113>
  801ec1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ec5:	77 0f                	ja     801ed6 <__umoddi3+0x122>
  801ec7:	89 f2                	mov    %esi,%edx
  801ec9:	29 f9                	sub    %edi,%ecx
  801ecb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ecf:	89 14 24             	mov    %edx,(%esp)
  801ed2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ed6:	8b 44 24 04          	mov    0x4(%esp),%eax
  801eda:	8b 14 24             	mov    (%esp),%edx
  801edd:	83 c4 1c             	add    $0x1c,%esp
  801ee0:	5b                   	pop    %ebx
  801ee1:	5e                   	pop    %esi
  801ee2:	5f                   	pop    %edi
  801ee3:	5d                   	pop    %ebp
  801ee4:	c3                   	ret    
  801ee5:	8d 76 00             	lea    0x0(%esi),%esi
  801ee8:	2b 04 24             	sub    (%esp),%eax
  801eeb:	19 fa                	sbb    %edi,%edx
  801eed:	89 d1                	mov    %edx,%ecx
  801eef:	89 c6                	mov    %eax,%esi
  801ef1:	e9 71 ff ff ff       	jmp    801e67 <__umoddi3+0xb3>
  801ef6:	66 90                	xchg   %ax,%ax
  801ef8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801efc:	72 ea                	jb     801ee8 <__umoddi3+0x134>
  801efe:	89 d9                	mov    %ebx,%ecx
  801f00:	e9 62 ff ff ff       	jmp    801e67 <__umoddi3+0xb3>
