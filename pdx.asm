[org 100h]
[segment .text]

  push	si		

	mov	ax,13h
	int	10h		



	mov	cl,0		
PALETTE	mov	dx,3C8h		
	mov	al,cl
	out	dx,al		
	inc	dx		
	mov	al,0
	out	dx,al		
	mov	al,cl
	shr	al,1                                             
	out	dx,al		
	mov	al,cl
	cmp	al,64
	jc	OKPAL
	mov	ax,4A3Fh	
OKPAL	out	dx,al		
	loop	PALETTE		



	mov	bh,3*16		
	int	21h		
	jc	near ENDPROG	

	mov	ax,cs
	add	ah,16
	mov	ds,ax		
	add	ah,16
	mov	es,ax		



WATER	push	es		
	mov	ax,1130h	
	mov	bh,3		
	int	10h		

	mov	bx,TEXT		
	mov	si,64*256+38	
	call	DRAWTEX		
	mov	si,100*256+100
	call	DRAWTEX		
	mov	si,136*256+36
	call	DRAWTEX

	pop	es		



RANDOM	pop	si		
	lea	si,[esi+4*esi+7]
	mov	[si],byte 255	
	push	si		


	
WATLINE	mov	al,[di+1]
	add	al,[di-1]	
	add	al,[di+256]
	add	al,[di-256]
	shr	al,1		
	sub	al,[es:di]	
	jnc	OK		
	mov	al,0		
OK	stosb			
	or	di,di
	jnz	WATLINE		

	push	ds		

	push	es
	pop	ds		
	push	word 0A000h
	pop	es		



	mov	dl,0DAh		
FRAME	in	al,dx
	and	al,8
	jz	FRAME		



	mov	di,32		
	xor	si,si		
	mov	dl,200		
DRAW	mov	cl,128		
	rep	movsw		
	movzx	bx,[si]		
	or	bx,bx		
	jz	NOOSCIL		
	mov	[es:bx+di-128],byte 80	
	neg	bx			
	mov	[es:bx+di-128],byte 80
NOOSCIL	add	di,byte 64	
	dec	dl
	jnz	DRAW		

	pop	es		

	in	al,60h		
	dec	al
	jnz	near WATER	

	mov	ax,03h
	int	10h		

	pop	si		
ENDPROG	ret			



DRAWTEX	movzx	di,byte [cs:bx]	
	inc	bx		
	shl	di,3		
	jz	ENDPROG		
	mov	cl,8		
CHARLIN	mov	al,[es:bp+di]	
	inc	di		
	mov	ch,8		
ROTATE	shl	al,1		
	jnc	NOPIXEL		
	add	[si],dword 02040304h	
NOPIXEL	add	si,byte 4	
	dec	ch
	jnz	ROTATE		
	add	si,1024-32	
	loop	CHARLIN		
	add	si,32-8192	
	jmp	DRAWTEX		

TEXT	db	"Paradox",0	
	db	"by",0
	db	"Azizjon Mamashoev",0
