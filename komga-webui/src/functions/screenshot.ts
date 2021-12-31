import html2canvas from 'html2canvas'

export async function partialScreenshot(element: any): Promise<string> {
    return html2canvas(
      element,
      {
        allowTaint: true,
        useCORS: true,
        x: window.scrollX,
        y: window.scrollY,
        width: window.innerWidth,
        height: window.innerHeight,
      })
      .then(function(canvas: any) {
          return returnBlob(canvas)
      })
  }

function returnBlob(canvas: any): string {
    const link = document.createElement('a')
    link.download = 'image.png'
    return canvas.toDataURL('image/png', 1.0)
}
